/// كيان المادة (المنتج) كما يرجعه الـ API في نقطة `/api/materials/`.
///
/// مصمّم بشكل مستقل عن تفاصيل الشبكة؛ الحقول النصية تُترك فارغة عند غيابها،
/// والأسعار تُحوَّل إلى `double`، والصور والمواصفات تُقرأ عبر Getters مريحة للعرض.
class MaterialEntity {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final String description;
  final String descriptionEn;
  final String descriptionAr;

  /// معرّف الفئة (FK).
  final int category;
  final String categoryName;

  /// معرّف وحدة القياس (FK) واسمها للعرض.
  final int uom;
  final String uomName;

  /// معرّف الشركة (FK) واسمها للعرض.
  final int? companyId;
  final String companyName;

  final double supplierPrice;
  final double consumerPrice;

  /// الأسعار بالليرة السورية (SP) كما يرسلها الـ API في حقول
  /// `supplier_price_in_sp` و`customer_price_in_sp`.
  final double supplierPriceInSp;
  final double customerPriceInSp;
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

  /// رابط معلوماتي اختياري (`info_url`) يفتح في المتصفح.
  final String? infoUrl;

  /// ملف معلوماتي اختياري (`info_file`): PDF أو صورة، حسب الامتداد.
  final String? infoFile;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MaterialEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.description,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.category,
    required this.categoryName,
    required this.uom,
    required this.uomName,
    required this.companyId,
    required this.companyName,
    required this.supplierPrice,
    required this.consumerPrice,
    this.supplierPriceInSp = 0,
    this.customerPriceInSp = 0,
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
    this.infoUrl,
    this.infoFile,
    required this.createdAt,
    required this.updatedAt,
  });

  /// أول صورة متوفرة للمادة (أو null إذا لم تكن هناك صور).
  String? get image => image1 ?? image2 ?? image3 ?? image4 ?? image5;

  /// الاسم المناسب للعرض بالعربية أولاً ثم الاسم العام.
  String get displayTitle => nameAr.isNotEmpty ? nameAr : name;

  /// الوصف المناسب للعرض بالعربية أولاً ثم الوصف العام.
  String get displayDescription =>
      descriptionAr.isNotEmpty ? descriptionAr : description;

  /// سعر المستهلك بصيغة نصية مناسبة للعرض (بدون كسور إذا كان صحيحاً).
  String get consumerPriceLabel =>
      consumerPrice == consumerPrice.roundToDouble()
      ? consumerPrice.toStringAsFixed(0)
      : consumerPrice.toStringAsFixed(2);

  /// سعر المستهلك بالليرة السورية بصيغة نصية مع فواصل الآلاف (مثل 25,200).
  String get customerPriceInSpLabel => _formatWithThousands(customerPriceInSp);

  /// إدراج فواصل الآلاف في رقم نصي: "25200" -> "25,200".
  static String _formatWithThousands(double value) {
    final rounded = value.roundToDouble();
    final isWhole = value == rounded;
    final digits = isWhole
        ? rounded.toStringAsFixed(0)
        : value.toStringAsFixed(2);

    final parts = digits.split('.');
    final intPart = parts[0];
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return parts.length > 1 ? '$buffer.${parts[1]}' : buffer.toString();
  }

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
