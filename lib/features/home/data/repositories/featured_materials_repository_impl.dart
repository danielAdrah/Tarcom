import '../../domain/entities/featured_materials_response_entity.dart';
import '../../domain/repositories/featured_materials_repository.dart';
import '../datasources/featured_materials_remote_data_source.dart';

class FeaturedMaterialsRepositoryImpl implements FeaturedMaterialsRepository {
  final FeaturedMaterialsRemoteDataSource remoteDataSource;

  const FeaturedMaterialsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FeaturedMaterialsResponseEntity> getFeaturedMaterials({
    int? page,
    int? pageSize,
    int? category,
    String? company,
    bool? isActive,
    String? search,
    String? ordering,
  }) async {
    return await remoteDataSource.getFeaturedMaterials(
      page: page,
      pageSize: pageSize,
      category: category,
      company: company,
      isActive: isActive,
      search: search,
      ordering: ordering,
    );
  }
}
