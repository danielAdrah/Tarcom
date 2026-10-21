import '../../domain/entities/material_detail_entity.dart';

class MaterialDetailModel extends MaterialDetailEntity {
  const MaterialDetailModel({
    required super.id,
    required super.name,
    required super.consumerPrice,
    required super.supplierPrice,
    required super.isActive,
    required super.image1,
    required super.category,
    required super.categoryName,
    required super.uom,
    required super.uomName,
    super.specKey1,
    super.specKey2,
    super.specKey3,
    super.specKey4,
    super.specKey5,
    super.specVal1,
    super.specVal2,
    super.specVal3,
    super.specVal4,
    super.specVal5,
  });

  factory MaterialDetailModel.fromJson(Map<String, dynamic> json) {
    return MaterialDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      // الأسعار تأتي نصياً مثل "1100.00" (أو رقم)، نحوّلها إلى double بأمان.
      consumerPrice: _parsePrice(json['consumer_price']),
      supplierPrice: _parsePrice(json['supplier_price']),
      isActive: json['is_active'] as bool? ?? false,
      image1: json['image1'] as String?,
      category: (json['category'] as num?)?.toInt(),
      categoryName: json['category_name'] as String? ?? '',
      uom: (json['uom'] as num?)?.toInt(),
      uomName: json['uom_name'] as String? ?? '',
      specKey1: json['spec_key1'] as String?,
      specKey2: json['spec_key2'] as String?,
      specKey3: json['spec_key3'] as String?,
      specKey4: json['spec_key4'] as String?,
      specKey5: json['spec_key5'] as String?,
      specVal1: json['spec_val1'] as String?,
      specVal2: json['spec_val2'] as String?,
      specVal3: json['spec_val3'] as String?,
      specVal4: json['spec_val4'] as String?,
      specVal5: json['spec_val5'] as String?,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
