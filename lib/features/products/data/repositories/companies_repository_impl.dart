import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/companies_repository.dart';
import '../datasources/companies_remote_data_source.dart';

class CompaniesRepositoryImpl implements CompaniesRepository {
  final CompaniesRemoteDataSource remoteDataSource;

  const CompaniesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CompanyEntity>> getMaterialCompanies({
    int? categoryId,
    bool? isActive,
    String? categoryInternalName,
  }) async {
    return await remoteDataSource.getMaterialCompanies(
      categoryId: categoryId,
      isActive: isActive,
      categoryInternalName: categoryInternalName,
    );
  }
}
