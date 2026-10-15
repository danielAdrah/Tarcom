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
/// عند التبديل نعتمد على راية `is_favourite` في استجابة الـ API لتحديث
/// الواجهة فوراً: إن أصبحت `false` نُزيل العنصر من القائمة محلياً.
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
    // التحديث بالسحب: نُبقي القائمة الظاهرة بدلاً من شاشة تحميل كاملة.
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
      // إعادة بناء معرّفات المفضلة من القائمة المجلوبة حديثاً.
      _favoriteIds
        ..clear()
        ..addAll(_favorites.map((f) => f.materialId));
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
        // تمت الإضافة: سجّل المعرّف كمُفضَّل (قد لا يكون في القائمة المحمّلة).
        _favoriteIds.add(event.materialId);
      } else {
        // تمت الإزالة: حدّث المجموعة وأزل العنصر من القائمة إن وُجد.
        _favoriteIds.remove(event.materialId);
        _favorites = _favorites
            .where((f) => f.materialId != event.materialId)
            .toList();
        _count = _favorites.length;
      }

      _togglingIds.remove(event.materialId);
      emit(_success(message: result.message));
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
    return FavoritesSuccess(
      favorites: _favorites,
      count: _count,
      favoriteIds: Set<int>.unmodifiable(_favoriteIds),
      togglingIds: Set<int>.unmodifiable(_togglingIds),
      lastMessage: message,
      lastError: errorMessage,
    );
  }
}
