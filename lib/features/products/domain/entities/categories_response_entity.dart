import 'category_entity.dart';

class CategoriesResponseEntity {
  final int count;
  final String? next;
  final String? previous;
  final List<CategoryEntity> results;

  const CategoriesResponseEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}
