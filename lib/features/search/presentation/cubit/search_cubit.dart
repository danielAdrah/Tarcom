import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/errors/api_excptions.dart';
import '../../../products/domain/entities/material_entity.dart';
import '../../../products/domain/usecases/get_materials_use_case.dart';

part 'search_state.dart';

/// Cubit البحث الفوري في الصفحة الرئيسية.
///
/// يعيد استخدام [GetMaterialsUseCase] القائمة (معامل `search` مدعوم أصلاً
/// عبر الطبقات)، ويضيف:
/// - تأخير (debounce) لتفادي إغراق الـ API مع كل ضغطة مفتاح.
/// - تجاهل الردود المتقادمة عبر `_requestId` حتى لا تومض نتائج قديمة.
/// - ذاكرة صغيرة (micro-cache) لتسريع المسح للخلف (backspacing).
/// - عدم إطلاق أي طلب قبل بلوغ الحد الأدنى لأحرف البحث.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.getMaterialsUseCase})
    : super(const SearchInitial());

  final GetMaterialsUseCase getMaterialsUseCase;

  static const Duration _debounceDuration = Duration(milliseconds: 400);
  static const int _minQueryLength = 2;
  static const int _pageSize = 6;
  static const int _maxCacheEntries = 20;

  Timer? _debounce;
  int _requestId = 0;
  final Map<String, List<MaterialEntity>> _cache = {};

  /// يُستدعى عند تغيّر نص الحقل: يضبط المؤقت أو يُغلق اللوحة للنصوص القصيرة.
  void onQueryChanged(String rawQuery) {
    final query = rawQuery.trim();

    if (query.length < _minQueryLength) {
      _cancelPending();
      emit(const SearchInitial());
      return;
    }

    // إظهار حالة التحميل فوراً ثم تنفيذ البحث بعد انتهاء المؤقت.
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => _runSearch(query));
  }

  /// إغلاق اللوحة (فقدان التركيز / مسح النص) مع إبطال أي طلب جارٍ.
  void dismiss() {
    _cancelPending();
    emit(const SearchInitial());
  }

  /// إعادة المحاولة بعد خطأ، بنفس النص الحالي للبحث.
  void retry(String rawQuery) {
    final query = rawQuery.trim();
    if (query.length < _minQueryLength) return;
    _runSearch(query);
  }

  void _cancelPending() {
    _debounce?.cancel();
    _debounce = null;
    // رفع المعرّف لجعل أي رد قيد التنفيذ متقادماً.
    _requestId++;
  }

  Future<void> _runSearch(String query) async {
    final key = _normalizeKey(query);
    final cached = _cache[key];
    if (cached != null) {
      // نتجاهل الكاش إذا بدأ بحث أحدث أثناء الطريق (نادر لكن محتمل).
      emit(_stateFromResults(query, cached));
      return;
    }

    final requestId = ++_requestId;
    emit(SearchLoading(query));

    try {
      final response = await getMaterialsUseCase(
        category: null,
        company: null,
        isActive: true,
        search: query,
        ordering: '-created_at',
        page: 1,
        pageSize: _pageSize,
      );

      if (requestId != _requestId) return; // رد متقادم — نتجاهله.

      final items = response.results;
      _storeInCache(key, items);
      emit(_stateFromResults(query, items, totalCount: response.count));
    } on ApiException catch (e) {
      if (requestId != _requestId) return;
      emit(SearchFailure(e.message));
    } catch (_) {
      if (requestId != _requestId) return;
      emit(const SearchFailure('حدث خطأ غير متوقع. حاول مرة أخرى.'));
    }
  }

  SearchState _stateFromResults(
    String query,
    List<MaterialEntity> items, {
    int? totalCount,
  }) {
    if (items.isEmpty) return SearchEmpty(query);
    final total = totalCount ?? items.length;
    return SearchResults(
      query: query,
      items: items,
      truncated: total > items.length,
    );
  }

  void _storeInCache(String key, List<MaterialEntity> items) {
    // لا نخزّن حالات الفشل؛ فقط النتائج الناجحة (بما فيها الفراغ).
    if (_cache.length >= _maxCacheEntries) _cache.clear();
    _cache[key] = items;
  }

  String _normalizeKey(String query) =>
      query.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
