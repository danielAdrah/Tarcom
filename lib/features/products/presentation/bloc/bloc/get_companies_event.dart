part of 'get_companies_bloc.dart';

sealed class GetCompaniesEvent extends Equatable {
  const GetCompaniesEvent();

  /// معرّف الفئة المرشّحة؛ null يعني جلب كل الشركات.
  int? get categoryId => null;

  /// تقييد النتائج بمواد نشطة فقط؛ null يعني بدون تقييد.
  bool? get isActive => null;

  /// الاسم الداخلي للفئة؛ null يعني بدون تقييد.
  String? get categoryInternalName => null;

  @override
  List<Object> get props => [?categoryId, ?isActive, ?categoryInternalName];
}

/// جلب شركات الفئة المحددة لأول مرة أو إعادة المحاولة بعد الفشل.
/// [categoryId] فارغ يعني جلب كل الشركات، و[isActive] يقيّد النتائج بالمواد النشطة.
class GetCompaniesRequested extends GetCompaniesEvent {
  const GetCompaniesRequested({
    this.categoryId,
    this.isActive,
    this.categoryInternalName,
  });

  @override
  final int? categoryId;
  @override
  final bool? isActive;
  @override
  final String? categoryInternalName;
}

/// إعادة جلب الشركات، مثلاً عند السحب للتحديث.
class GetCompaniesRefreshRequested extends GetCompaniesEvent {
  const GetCompaniesRefreshRequested({
    this.categoryId,
    this.isActive,
    this.categoryInternalName,
  });

  @override
  final int? categoryId;
  @override
  final bool? isActive;
  @override
  final String? categoryInternalName;
}

/// إعادة الحالة إلى Initial.
class GetCompaniesReset extends GetCompaniesEvent {
  const GetCompaniesReset();
}
