/// تفاصيل المادة كما ترجعها واجهة المفضلة داخل حقل `material_detail`.
///
/// تحتوي فقط على الحقول اللازمة لعرض المنتج في قائمة المفضلة،
/// وهي أدنى من كيان المادة الكامل المستخدم في الصفحات الأخرى.
class MaterialDetailEntity {
  final int id;
  final String name;
  final double consumerPrice;
  final double supplierPrice;
  final bool isActive;
  final String? image1;
  final int? category;
  final String categoryName;
  final int? uom;
  final String uomName;
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

  const MaterialDetailEntity({
    required this.id,
    required this.name,
    required this.consumerPrice,
    required this.supplierPrice,
    required this.isActive,
    required this.image1,
    required this.category,
    required this.categoryName,
    required this.uom,
    required this.uomName,
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

  /// صورة المنتج للعرض (قد تكون null حسب الـ API).
  String? get image => image1;

  /// المواصفات كأزواج (مفتاح → قيمة) مع تجاهل الأزواج الناقصة أو الفارغة.
  ///
  /// تُبنى من الحقول `spec_key1..5` / `spec_val1..5` في استجابة المفضلة.
  List<({String key, String value})> get specs {
    final pairs = <({String? key, String? value})>[
      (key: specKey1, value: specVal1),
      (key: specKey2, value: specVal2),
      (key: specKey3, value: specVal3),
      (key: specKey4, value: specVal4),
      (key: specKey5, value: specVal5),
    ];
    return pairs
        .where(
          (p) =>
              p.key != null &&
              p.key!.isNotEmpty &&
              p.value != null &&
              p.value!.isNotEmpty,
        )
        .map((p) => (key: p.key!, value: p.value!))
        .toList();
  }

  /// سعر المستهلك بصيغة نصية مناسبة للعرض (بدون كسور إذا كان صحيحاً).
  String get consumerPriceLabel =>
      consumerPrice == consumerPrice.roundToDouble()
      ? consumerPrice.toStringAsFixed(0)
      : consumerPrice.toStringAsFixed(2);
}
