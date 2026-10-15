part of 'get_materials_bloc.dart';

/// حزمة معاملات الفلترة الثابتة المستخدمة في جلب المواد (بدون الترقيم).
class _MaterialsFilter {
  const _MaterialsFilter({
    this.category,
    this.company,
    this.companyName,
    this.isActive,
    this.search,
    this.ordering,
    this.specKey1,
    this.specKey2,
    this.specKey3,
    this.specKey4,
    this.specKey5,
    this.specVal1,
    this.specVal2,
    this.specVal3,
    this.specVal4,
    this.specVal5,
  });

  final int? category;
  final int? company;
  final String? companyName;
  final bool? isActive;
  final String? search;
  final String? ordering;
  final String? specKey1;
  final String? specKey2;
  final String? specKey3;
  final String? specKey4;
  final String? specKey5;
  final String? specVal1;
  final String? specVal2;
  final String? specVal3;
  final String? specVal4;
  final String? specVal5;
}

sealed class GetMaterialsEvent extends Equatable {
  const GetMaterialsEvent();

  @override
  List<Object?> get props => [];
}

/// جلب المواد المفلترة لأول مرة أو بعد تغيّر عوامل الفلترة/البحث.
/// [category] و[company] إلزاميان حسب الـ API؛ بقية المعاملات اختيارية.
class GetMaterialsRequested extends GetMaterialsEvent {
  const GetMaterialsRequested({
    this.category,
    this.company,
    this.companyName,
    this.isActive,
    this.search,
    this.ordering,
    this.specKey1,
    this.specKey2,
    this.specKey3,
    this.specKey4,
    this.specKey5,
    this.specVal1,
    this.specVal2,
    this.specVal3,
    this.specVal4,
    this.specVal5,
    this.pageSize,
  });

  final int? category;
  final int? company;
  final String? companyName;
  final bool? isActive;
  final String? search;
  final String? ordering;
  final String? specKey1;
  final String? specKey2;
  final String? specKey3;
  final String? specKey4;
  final String? specKey5;
  final String? specVal1;
  final String? specVal2;
  final String? specVal3;
  final String? specVal4;
  final String? specVal5;
  final int? pageSize;

  _MaterialsFilter _toFilter() => _MaterialsFilter(
    category: category,
    company: company,
    companyName: companyName,
    isActive: isActive,
    search: search,
    ordering: ordering,
    specKey1: specKey1,
    specKey2: specKey2,
    specKey3: specKey3,
    specKey4: specKey4,
    specKey5: specKey5,
    specVal1: specVal1,
    specVal2: specVal2,
    specVal3: specVal3,
    specVal4: specVal4,
    specVal5: specVal5,
  );

  @override
  List<Object?> get props => [
    category,
    company,
    companyName,
    isActive,
    search,
    ordering,
    specKey1,
    specKey2,
    specKey3,
    specKey4,
    specKey5,
    specVal1,
    specVal2,
    specVal3,
    specVal4,
    specVal5,
    pageSize,
  ];
}

/// إعادة جلب المواد من الصفحة الأولى بنفس معاملات الفلترة الحالية (السحب للتحديث).
class GetMaterialsRefreshRequested extends GetMaterialsEvent {
  const GetMaterialsRefreshRequested();
}

/// جلب الصفحة التالية وإضافتها إلى النتائج (تحميل غير منتهي).
class GetMaterialsLoadMoreRequested extends GetMaterialsEvent {
  const GetMaterialsLoadMoreRequested();
}

/// إعادة الحالة إلى Initial وتفريغ المعاملات والنتائج.
class GetMaterialsReset extends GetMaterialsEvent {
  const GetMaterialsReset();
}
