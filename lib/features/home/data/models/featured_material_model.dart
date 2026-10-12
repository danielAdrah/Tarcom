import '../../domain/entities/featured_material_entity.dart';
import 'category_detail_model.dart';
import 'uom_detail_model.dart';

class FeaturedMaterialModel extends FeaturedMaterialEntity {
  const FeaturedMaterialModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.nameAr,
    required super.description,
    required super.descriptionEn,
    required super.descriptionAr,
    required super.category,
    required super.categoryName,
    required super.categoryDetail,
    required super.uom,
    required super.uomName,
    required super.uomDetail,
    required super.company,
    required super.supplierPrice,
    required super.consumerPrice,
    required super.isActive,
    required super.expireDate,
    required super.specKey1,
    required super.specKey2,
    required super.specKey3,
    required super.specKey4,
    required super.specKey5,
    required super.specVal1,
    required super.specVal2,
    required super.specVal3,
    required super.specVal4,
    required super.specVal5,
    required super.image1,
    required super.image2,
    required super.image3,
    required super.image4,
    required super.image5,
    required super.createdAt,
    required super.updatedAt,
    required super.featureReason,
  });

  factory FeaturedMaterialModel.fromJson(Map<String, dynamic> json) {
    return FeaturedMaterialModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      description: json['description'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      category: json['category'] as int? ?? 0,
      categoryName: json['category_name'] as String? ?? '',
      categoryDetail: json['category_detail'] is Map<String, dynamic>
          ? CategoryDetailModel.fromJson(
              json['category_detail'] as Map<String, dynamic>,
            )
          : null,
      uom: json['uom'] as int? ?? 0,
      uomName: json['uom_name'] as String? ?? '',
      uomDetail: json['uom_detail'] is Map<String, dynamic>
          ? UomDetailModel.fromJson(json['uom_detail'] as Map<String, dynamic>)
          : null,
      company: json['company'] as String? ?? '',
      supplierPrice: _parsePrice(json['supplier_price']),
      consumerPrice: _parsePrice(json['consumer_price']),
      isActive: json['is_active'] as bool? ?? false,
      expireDate: DateTime.tryParse(json['expire_date'] as String? ?? ''),
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
      image1: json['image1'] as String?,
      image2: json['image2'] as String?,
      image3: json['image3'] as String?,
      image4: json['image4'] as String?,
      image5: json['image5'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      featureReason: FeatureReason.fromValue(json['feature_reason'] as String?),
    );
  }

  /// السعر يأتي من الـ API كنص مثل "700.00" (أو رقم)، نحوّله إلى double بأمان.
  static double _parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
