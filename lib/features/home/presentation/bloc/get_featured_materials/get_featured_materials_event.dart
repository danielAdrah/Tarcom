part of 'get_featured_materials_bloc.dart';

sealed class GetFeaturedMaterialsEvent extends Equatable {
  const GetFeaturedMaterialsEvent();

  @override
  List<Object> get props => [];
}

/// جلب المواد المميزة لأول مرة أو إعادة المحاولة بعد الفشل.
/// يمكن تحديد حجم الصفحة؛ الافتراضي 10 (الصفحة الأولى فقط).
class GetFeaturedMaterialsRequested extends GetFeaturedMaterialsEvent {
  const GetFeaturedMaterialsRequested({this.pageSize});

  final int? pageSize;

  @override
  List<Object> get props => [?pageSize];
}

/// إعادة جلب المواد المميزة من الصفحة الأولى، مثلاً عند السحب للتحديث.
class GetFeaturedMaterialsRefreshRequested extends GetFeaturedMaterialsEvent {
  const GetFeaturedMaterialsRefreshRequested();
}

/// جلب الصفحة التالية وإضافتها إلى النتائج (تحميل غير منتهي).
class GetFeaturedMaterialsLoadMoreRequested extends GetFeaturedMaterialsEvent {
  const GetFeaturedMaterialsLoadMoreRequested();
}

/// إعادة الحالة إلى Initial.
class GetFeaturedMaterialsReset extends GetFeaturedMaterialsEvent {
  const GetFeaturedMaterialsReset();
}
