import '../entities/company_entity.dart';

abstract class CompaniesRepository {
  Future<List<CompanyEntity>> getMaterialCompanies({
    int? categoryId,
    bool? isActive,
    String? categoryInternalName,
  });
}
