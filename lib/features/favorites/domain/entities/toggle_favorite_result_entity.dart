/// نتيجة عملية تبديل المفضلة من `POST /api/favourites/toggle/`.
///
/// يحمل الحالة الجديدة للعنصر (`isFavourite`) ورسالة نصية جاهزة للعرض
/// (عربية حسب ترويسة `Accept-Language` الافتراضية للـ API).
class ToggleFavoriteResultEntity {
  final bool isFavourite;
  final String message;

  const ToggleFavoriteResultEntity({
    required this.isFavourite,
    required this.message,
  });
}
