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
  });

  /// صورة المنتج للعرض (قد تكون null حسب الـ API).
  String? get image => image1;

  /// سعر المستهلك بصيغة نصية مناسبة للعرض (بدون كسور إذا كان صحيحاً).
  String get consumerPriceLabel =>
      consumerPrice == consumerPrice.roundToDouble()
      ? consumerPrice.toStringAsFixed(0)
      : consumerPrice.toStringAsFixed(2);
}
