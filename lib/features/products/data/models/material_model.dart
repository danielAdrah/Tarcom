import '../../domain/entities/material_entity.dart';

/// نموذج المادة القادم من `/api/materials/`. يحوّل JSON إلى [MaterialEntity].
class MaterialModel extends MaterialEntity {
  const MaterialModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.nameAr,
    required super.description,
    required super.descriptionEn,
    required super.descriptionAr,
    required super.category,
    required super.categoryName,
    required super.uom,
    required super.uomName,
    required super.companyId,
    required super.companyName,
    required super.supplierPrice,
    required super.consumerPrice,
    super.supplierPriceInSp,
    super.customerPriceInSp,
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
    super.infoUrl,
    super.infoFile,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    final categoryDetail = _asMap(json['category_detail']);
    final companyDetail = _asMap(json['company_detail']);
    final uomDetail = _asMap(json['uom_detail']);

    return MaterialModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      description: json['description'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      category: (json['category'] as num?)?.toInt() ?? 0,
      categoryName:
          json['category_name'] as String? ??
          categoryDetail?['name'] as String? ??
          '',
      uom: (json['uom'] as num?)?.toInt() ?? 0,
      uomName:
          json['uom_name'] as String? ?? uomDetail?['name'] as String? ?? '',
      // `company` معرّف الشركة (FK)؛ نقرأه بمرونة لتحمل أي شكل رقمي.
      companyId: (json['company'] as num?)?.toInt(),
      // الـ API لا يرجع `company_name` دائماً، بل `company_detail.name`.
      companyName:
          companyDetail?['name'] as String? ??
          json['company_name'] as String? ??
          '',
      supplierPrice: _parsePrice(json['supplier_price']),
      consumerPrice: _parsePrice(json['consumer_price']),
      // الأسعار بالليرة السورية: حقول جديدة `supplier_price_in_sp` و`customer_price_in_sp`.
      supplierPriceInSp: _parsePrice(json['supplier_price_in_sp']),
      customerPriceInSp: _parsePrice(json['customer_price_in_sp']),
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
      // حقول اختيارية جديدة: رابط/ملف المعلومات. تُترك null عند الغياب.
      infoUrl: (json['info_url'] as String?)?.trim().isNotEmpty == true
          ? (json['info_url'] as String).trim()
          : null,
      infoFile: (json['info_file'] as String?)?.trim().isNotEmpty == true
          ? (json['info_file'] as String).trim()
          : null,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// السعر يأتي من الـ API كنص مثل "700.00" (أو رقم)، نحوّله إلى double بأمان.
  static double _parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// يُرجع القيمة كخريطة ديناميكية إن كانت كذلك، وإلا null.
  static Map<String, dynamic>? _asMap(dynamic value) {
    return value is Map<String, dynamic> ? value : null;
  }
}
