import '../../domain/entities/materials_response_entity.dart';
import '../../domain/repositories/materials_repository.dart';
import '../datasources/materials_remote_data_source.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final MaterialsRemoteDataSource remoteDataSource;

  const MaterialsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MaterialsResponseEntity> getMaterials({
    required int? category,
    required int? company,
    String? companyName,
    bool? isActive,
    String? search,
    String? ordering,
    String? specKey1,
    String? specKey2,
    String? specKey3,
    String? specKey4,
    String? specKey5,
    String? specVal1,
    String? specVal2,
    String? specVal3,
    String? specVal4,
    String? specVal5,
    int? page,
    int? pageSize,
  }) async {
    return await remoteDataSource.getMaterials(
      category: category,
      company: company,
      companyName: companyName,
      isActive: isActive,
      search: search,
      ordering: ordering,
      specKey1: specKey1,
      specKey2: specKey2,
      specKey3: specKey3,
      specKey4: specKey4,
      specKey5: specKey5,
      specVal1: specVal1,
      specVal2: specVal2,
      specVal3: specVal3,
      specVal4: specVal4,
      specVal5: specVal5,
      page: page,
      pageSize: pageSize,
    );
  }
}
