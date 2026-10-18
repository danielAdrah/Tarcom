class CategoryEntity {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final String internalName;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.internalName,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}
