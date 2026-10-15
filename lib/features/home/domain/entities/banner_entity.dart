/// كيان لافتات الموقع (Site Banners) كما ترجعه نقطة `/api/banners/`.
///
/// الاستجابة مصفوفة بسيطة لكل عنصر الحقول:
/// `{id, title, image, is_active, created_at, updated_at}`.
class BannerEntity {
  final int id;
  final String title;
  final String image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
