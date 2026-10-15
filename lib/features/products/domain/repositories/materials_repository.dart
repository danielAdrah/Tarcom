import '../entities/materials_response_entity.dart';

/// عقد جلب المواد (المنتجات) مع فلترة حسب الفئة والشركة.
///
/// `category` و`company` إلزاميان حسب الـ API (يُمرَّر `null` عند عدم توفر المعرّف).
/// بقية المعاملات اختيارية: `companyName`, `isActive`, `search`, `ordering`،
/// إضافة إلى مرشّحات المواصفات `specKey1..5` / `specVal1..5`، والترقيم `page` / `pageSize`.
abstract class MaterialsRepository {
  Future<MaterialsResponseEntity> getMaterials({
    required int? category,
    required int? company,
    String? companyName,
    bool? isActive,
    String? search,
    String? ordering,
    String? specKey1,
    String? specKey2,
    String? specKey3,
    String? specKey4,
    String? specKey5,
    String? specVal1,
    String? specVal2,
    String? specVal3,
    String? specVal4,
    String? specVal5,
    int? page,
    int? pageSize,
  });
}
