import '../../../../core/api/errors/api_excptions.dart';
import '../entities/company_entity.dart';
import '../repositories/companies_repository.dart';

class GetMaterialCompaniesUseCase {
  final CompaniesRepository repository;

  const GetMaterialCompaniesUseCase(this.repository);

  Future<List<CompanyEntity>> call({int? categoryId, bool? isActive}) async {
    try {
      return await repository.getMaterialCompanies(
        categoryId: categoryId,
        isActive: isActive,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
