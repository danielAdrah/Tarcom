import '../entities/categories_response_entity.dart';

abstract class CategoriesRepository {
  Future<CategoriesResponseEntity> getCategories();
}
