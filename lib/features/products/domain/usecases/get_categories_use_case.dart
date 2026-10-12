import '../../../../core/api/errors/api_excptions.dart';
import '../entities/categories_response_entity.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository repository;

  const GetCategoriesUseCase(this.repository);

  Future<CategoriesResponseEntity> call() async {
    try {
      return await repository.getCategories();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
