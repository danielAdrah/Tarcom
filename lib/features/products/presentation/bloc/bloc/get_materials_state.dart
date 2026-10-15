part of 'get_materials_bloc.dart';

sealed class GetMaterialsState extends Equatable {
  const GetMaterialsState();

  @override
  List<Object> get props => [];
}

final class GetMaterialsInitial extends GetMaterialsState {}

/// أثناء تحميل الصفحة الأولى من المواد.
class GetMaterialsLoading extends GetMaterialsState {
  const GetMaterialsLoading();
}

/// تم جلب المواد بنجاح.
/// يدعم التحميل غير المنتهي عبر [isLoadingMore] و[hasMore] و[loadMoreError].
class GetMaterialsSuccess extends GetMaterialsState {
  final List<MaterialEntity> materials;
  final int count;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  const GetMaterialsSuccess({
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

/// فشل طلب جلب المواد (الصفحة الأولى).
class GetMaterialsFailure extends GetMaterialsState {
  final String message;
  final ApiException? exception;

  const GetMaterialsFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
