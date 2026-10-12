class CategoryEntity {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final String icon;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.icon,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}
