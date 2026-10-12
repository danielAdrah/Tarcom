part of 'get_featured_materials_bloc.dart';

sealed class GetFeaturedMaterialsState extends Equatable {
  const GetFeaturedMaterialsState();

  @override
  List<Object> get props => [];
}

final class GetFeaturedMaterialsInitial extends GetFeaturedMaterialsState {}

/// أثناء تحميل المواد المميزة (الصفحة الأولى).
class GetFeaturedMaterialsLoading extends GetFeaturedMaterialsState {
  const GetFeaturedMaterialsLoading();
}

/// تم جلب المواد المميزة بنجاح.
/// يدعم التحميل غير المنتهي عبر [isLoadingMore] و[hasMore] و[loadMoreError].
class GetFeaturedMaterialsSuccess extends GetFeaturedMaterialsState {
  final List<FeaturedMaterialEntity> materials;
  final int count;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  const GetFeaturedMaterialsSuccess({
    required this.materials,
    required this.count,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  @override
  List<Object> get props => [
    materials,
    count,
    hasMore,
    isLoadingMore,
    ?loadMoreError,
  ];
}

/// فشل طلب جلب المواد المميزة (الصفحة الأولى).
class GetFeaturedMaterialsFailure extends GetFeaturedMaterialsState {
  final String message;
  final ApiException? exception;

  const GetFeaturedMaterialsFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
