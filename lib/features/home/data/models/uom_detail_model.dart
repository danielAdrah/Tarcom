import '../../domain/entities/uom_detail_entity.dart';

class UomDetailModel extends UomDetailEntity {
  const UomDetailModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.nameAr,
    required super.code,
  });

  factory UomDetailModel.fromJson(Map<String, dynamic> json) {
    return UomDetailModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }
}
