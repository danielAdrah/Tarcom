import '../../domain/entities/categories_response_entity.dart';
import '../../domain/entities/category_entity.dart';
import 'category_model.dart';

class CategoriesResponseModel extends CategoriesResponseEntity {
  const CategoriesResponseModel({
    required super.count,
    required super.next,
    required super.previous,
    required super.results,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return CategoriesResponseModel(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsJson
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList()
          .cast<CategoryEntity>(),
    );
  }
}
