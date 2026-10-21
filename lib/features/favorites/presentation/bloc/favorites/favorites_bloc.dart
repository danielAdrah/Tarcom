import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/favorite_material_entity.dart';
import '../../../domain/usecases/get_favorites_use_case.dart';
import '../../../domain/usecases/toggle_favorite_use_case.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

/// يدير حالة قائمة المفضلة: الجلب، التحديث، وتبديل حالة عنصر.
///
/// يُوفَّر هذا الـ Bloc على جذر التطبيق (انظر `main.dart`) كنسخة واحدة
/// مشتركة، فتقرأ كل الصفحات (الرئيسية/المنتجات/التفاصيل/البحث/المفضلة)
/// وتكتب نفس الحالة. عند تبديل عنصر في أي صفحة تُبعث حالة جديدة
/// فيعيد `BlocBuilder` في صفحة المفضلة البناء فوراً دون إعادة تشغيل.
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  // الحالة الداخلية المحفوظة عبر الأحداث.
  List<FavoriteMaterialEntity> _favorites = const [];
  int _count = 0;
  final Set<int> _togglingIds = <int>{};

  /// مصدر الحقيقة لحالة القلب في أي شاشة تعرض منتجات: مجموعة معرّفات المواد
  /// المُفضَّلة. تُعبّأ من قائمة المفضلة عند الجلب، وتُحدَّث فوراً حسب
  /// `is_favourite` العائد من عملية التبديل (حتى للمواد غير المدرجة في القائمة).
  final Set<int> _favoriteIds = <int>{};

  /// معرّفات تمت إضافتها بشكل تفاؤلي (optimistic) بعد نجاح `toggle` ولم
  /// تؤكّدها استجابة `get favourites` بعد. تُستخدم لمنع الجلب الخلفي من
  /// محو القلب في اللحظة التي يضغط فيها المستخدم، خصوصاً إذا كان الـ fetch
  /// سابقاً لتزامن الخادم.
  final Set<int> _pendingAdds = <int>{};

  /// عدّاد يتزايد مع كل انبعاث نجاح، لضمان اختلاف حالة `FavoritesSuccess`
  /// بين دفعتين حتى لو تطابق المحتوى (يمنع أي إلغاء إعادة بناء عبر
  /// Equatable equality عند حدوث تغيير حقيقي في الواجهة).
  int _revision = 0;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(FavoritesInitial()) {
    on<FavoritesRequested>(_onRequested);
    on<FavoritesRefreshRequested>(_onRefreshRequested);
    on<FavoriteToggled>(_onToggled);
  }

  Future<void> _onRequested(
    FavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    await _fetch(
      emit,
      name: event.name,
      ordering: event.ordering,
      showFullscreenLoading: true,
    );
  }

  Future<void> _onRefreshRequested(
    FavoritesRefreshRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    // التحديث بالسحب أو خلف التبديل: نُبقي القائمة الظاهرة بدلاً من شاشة كاملة.
    await _fetch(
      emit,
      name: event.name,
      ordering: event.ordering,
      showFullscreenLoading: false,
    );
  }

  Future<void> _fetch(
    Emitter<FavoritesState> emit, {
    String? name,
    String? ordering,
    required bool showFullscreenLoading,
  }) async {
    if (showFullscreenLoading) {
      emit(const FavoritesLoading());
    }

    try {
      final response = await getFavoritesUseCase(
        name: name,
        // الافتراضي حسب الـ API: الأحدث أولاً.
        ordering: (ordering == null || ordering.isEmpty)
            ? '-created_at'
            : ordering,
      );

      _favorites = response.results;
      _count = response.count;

      // إعادة بناء معرّفات المفضلة من القائمة المجلوبة حديثاً، مع
      // **عدم** محو المعرّفات المضافة تفاؤلياً أو قيد التبديل: هذه نافذة
      // يتعامل فيها الخادم مع آخر تبديل؛ محوها يعيد القلب فارغاً في
      // صفحة المنتجات ويوحي للمستخدم بأن التحديث لم يصل لصفحة المفضلة.
      final fetchedIds = _favorites.map((f) => f.materialId).toSet();
      _favoriteIds
        ..clear()
        ..addAll(fetchedIds)
        ..addAll(_pendingAdds)
        ..addAll(_togglingIds);
      // ما ظهر في الخادم لم يعد معلّقاً.
      _pendingAdds.removeWhere(fetchedIds.contains);

      emit(_success());
    } on ApiException catch (e) {
      emit(FavoritesFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const FavoritesFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'),
      );
    }
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    // تأثير فوري: ضع مؤشر انتظار على العنصر المطلوب تبديله.
    _togglingIds.add(event.materialId);
    emit(_success());

    try {
      final result = await toggleFavoriteUseCase(materialId: event.materialId);

      // تحديث الواجهة بناءً على `is_favourite` العائد من الخادم.
      if (result.isFavourite) {
        // تمت الإضافة: سجّل المعرّف كمُفضَّل بشكل تفاؤلي (قد لا يكون في القائمة المحمّلة).
        _favoriteIds.add(event.materialId);
        _pendingAdds.add(event.materialId);
      } else {
        // تمت الإزالة: حدّث المجموعة وأزل العنصر من القائمة إن وُجد.
        _favoriteIds.remove(event.materialId);
        _pendingAdds.remove(event.materialId);
        _favorites = _favorites
            .where((f) => f.materialId != event.materialId)
            .toList();
        _count = _favorites.length;
      }

      _togglingIds.remove(event.materialId);
      emit(_success(message: result.message));

      // عند الإضافة فقط: الكائن الكامل (`FavoriteMaterialEntity`) غير متاح
      // محلياً، فنطلب جلباً خلفياً عبر حدث `FavoritesRefreshRequested` حتى
      // تظهر المادة الجديدة في صفحة المفضلة فوراً. استخدام `add` بدل
      // استدعاء `_fetch` مباشرة يُبقي المعالجة داخل طابور الأحداث ولا
      // يُعرّض الانبعاث الحالي للتداخل مع طلبات متتابعة.
      if (result.isFavourite) {
        add(const FavoritesRefreshRequested());
      }
    } on ApiException catch (e) {
      // نُبقي القائمة كما هي ونبلّغ المستخدم بخطأ واضح.
      _togglingIds.remove(event.materialId);
      emit(_success(errorMessage: e.message));
    } catch (_) {
      _togglingIds.remove(event.materialId);
      emit(_success(errorMessage: 'تعذّرت تحديث المفضلة. حاول مرة أخرى.'));
    }
  }

  FavoritesSuccess _success({String? message, String? errorMessage}) {
    _revision++;
    return FavoritesSuccess(
      revision: _revision,
      favorites: _favorites,
      count: _count,
      favoriteIds: Set<int>.unmodifiable(_favoriteIds),
      togglingIds: Set<int>.unmodifiable(_togglingIds),
      lastMessage: message,
      lastError: errorMessage,
    );
  }
}
