import '../entities/featured_materials_response_entity.dart';

/// عقد جلب المواد المميزة (Featured Materials).
///
///جميع المعاملات اختيارية حسب الـ API:
///`category`, `company`, `is_active`, `search`, `ordering`, `page`, `page_size`.
abstract class FeaturedMaterialsRepository {
  Future<FeaturedMaterialsResponseEntity> getFeaturedMaterials({
    int? page,
    int? pageSize,
    int? category,
    String? company,
    bool? isActive,
    String? search,
    String? ordering,
  });
}
