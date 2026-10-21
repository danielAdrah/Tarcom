part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

/// أثناء التحميل الكامل (أول طلب أو إعادة المحاولة بعد الفشل).
final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// نجاح: قائمة المفضلة جاهزة للعرض.
///
/// - [favoriteIds]: معرّفات المواد المُفضَّلة (مصدر الحقيقة لحالة القلب).
/// - [togglingIds]: معرّفات المواد قيد التبديل لعرض مؤشر على بطاقتها.
/// - [lastMessage]/[lastError]: رسالة لمرة واحدة يستمع لها العرض (SnackBar).
/// - [revision]: عدّاد يتزايد مع كل انبعاث، لضمان اختلاف حالة
///   `FavoritesSuccess` بين دفعتين حتى لو تطابق المحتوى، فينتقل
///   `BlocBuilder` في صفحة المفضلة إلى بناء جديد فور أي تبديل.
final class FavoritesSuccess extends FavoritesState {
  final int revision;
  final List<FavoriteMaterialEntity> favorites;
  final int count;
  final Set<int> favoriteIds;
  final Set<int> togglingIds;
  final String? lastMessage;
  final String? lastError;

  const FavoritesSuccess({
    required this.revision,
    required this.favorites,
    required this.count,
    required this.favoriteIds,
    required this.togglingIds,
    this.lastMessage,
    this.lastError,
  });

  bool isFavorite(int materialId) => favoriteIds.contains(materialId);

  bool isToggling(int materialId) => togglingIds.contains(materialId);

  @override
  List<Object> get props => [
    revision,
    favorites,
    count,
    favoriteIds,
    togglingIds,
    lastMessage ?? '',
    lastError ?? '',
  ];
}

/// فشل طلب جلب المفضلة (الجلاء الكامل).
final class FavoritesFailure extends FavoritesState {
  final String message;
  final ApiException? exception;

  const FavoritesFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
