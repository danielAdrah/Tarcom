import 'category_detail_entity.dart';
import 'company_detail_entity.dart';
import 'uom_detail_entity.dart';

/// سبب تمييز المادة من الـ API: `OFFER` | `LIMITED_TIME` | `SPECIAL`.
enum FeatureReason {
  offer('OFFER'),
  limitedTime('LIMITED_TIME'),
  special('SPECIAL'),
  unknown('');

  const FeatureReason(this.value);

  final String value;

  static FeatureReason fromValue(String? value) {
    return FeatureReason.values.firstWhere(
      (reason) => reason.value == (value?.toUpperCase() ?? ''),
      orElse: () => FeatureReason.unknown,
    );
  }
}

class FeaturedMaterialEntity {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final String description;
  final String descriptionEn;
  final String descriptionAr;
  final int category;
  final String categoryName;
  final CategoryDetailEntity? categoryDetail;
  final int uom;
  final String uomName;
  final UomDetailEntity? uomDetail;

  /// معرّف الشركة (FK) كما يرجعه الـ API في حقل `company`.
  final int? companyId;
  final CompanyDetailEntity? companyDetail;
  final double supplierPrice;
  final double consumerPrice;
  final bool isActive;
  final DateTime? expireDate;
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
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? image5;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FeatureReason featureReason;

  const FeaturedMaterialEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.description,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.category,
    required this.categoryName,
    required this.categoryDetail,
    required this.uom,
    required this.uomName,
    required this.uomDetail,
    required this.companyId,
    required this.companyDetail,
    required this.supplierPrice,
    required this.consumerPrice,
    required this.isActive,
    required this.expireDate,
    required this.specKey1,
    required this.specKey2,
    required this.specKey3,
    required this.specKey4,
    required this.specKey5,
    required this.specVal1,
    required this.specVal2,
    required this.specVal3,
    required this.specVal4,
    required this.specVal5,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
    required this.createdAt,
    required this.updatedAt,
    required this.featureReason,
  });

  /// أول صورة متوفرة للمادة (أو null إذا لم تكن هناك صور).
  String? get image => image1 ?? image2 ?? image3 ?? image4 ?? image5;

  /// اسم الشركة للعرض؛ الـ API لا يرجع `company_name`، بل `company_detail`.
  String get companyName => companyDetail?.name ?? '';

  /// سعر المستهلك بصيغة نصية مناسبة للعرض (بدون كسور إذا كان صحيحاً).
  String get consumerPriceLabel =>
      consumerPrice == consumerPrice.roundToDouble()
      ? consumerPrice.toStringAsFixed(0)
      : consumerPrice.toStringAsFixed(2);

  /// الأزواج (اسم/قيمة) للمواصفات غير الفارغة، جاهزة لعرضها في صفحة التفاصيل.
  List<MapEntry<String, String>> get specifications {
    final pairs = <List<String?>>[
      [specKey1, specVal1],
      [specKey2, specVal2],
      [specKey3, specVal3],
      [specKey4, specVal4],
      [specKey5, specVal5],
    ];

    return pairs
        .where((pair) => (pair[0]?.isNotEmpty ?? false) && pair[1] != null)
        .map((pair) => MapEntry(pair[0]!, pair[1]!))
        .toList();
  }
}
