part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

/// جلب المفضلة لأول مرة أو بعد فشل. المعاملات اختيارية حسب الـ API.
class FavoritesRequested extends FavoritesEvent {
  const FavoritesRequested({this.name, this.ordering});

  final String? name;
  final String? ordering;

  @override
  List<Object> get props => [name ?? '', ordering ?? ''];
}

/// إعادة الجلب من الأعلى (السحب للتحديث) مع إبقاء القائمة الظاهرة.
class FavoritesRefreshRequested extends FavoritesEvent {
  const FavoritesRefreshRequested({this.name, this.ordering});

  final String? name;
  final String? ordering;

  @override
  List<Object> get props => [name ?? '', ordering ?? ''];
}

/// تبديل حالة مفضّلة لمادة معيّنة (إضافة/إزالة) عبر المعرّف.
class FavoriteToggled extends FavoritesEvent {
  const FavoriteToggled({required this.materialId});

  final int materialId;

  @override
  List<Object> get props => [materialId];
}
