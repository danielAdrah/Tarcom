import '../../../../core/api/errors/api_excptions.dart';
import '../entities/featured_materials_response_entity.dart';
import '../repositories/featured_materials_repository.dart';

class GetFeaturedMaterialsUseCase {
  final FeaturedMaterialsRepository repository;

  const GetFeaturedMaterialsUseCase(this.repository);

  Future<FeaturedMaterialsResponseEntity> call({
    int? page,
    int? pageSize,
    int? category,
    int? companyId,
    bool? isActive,
    String? search,
    String? ordering,
  }) async {
    try {
      return await repository.getFeaturedMaterials(
        page: page,
        pageSize: pageSize,
        category: category,
        companyId: companyId,
        isActive: isActive,
        search: search,
        ordering: ordering,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
