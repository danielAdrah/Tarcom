import '../../domain/entities/category_detail_entity.dart';

class CategoryDetailModel extends CategoryDetailEntity {
  const CategoryDetailModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.nameAr,
    required super.image,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
