import '../models/company_model.dart';

import '../../../../core/api/network/api_client.dart';
import '../../../../core/api/apiKeys/end_point.dart';

abstract class CompaniesRemoteDataSource {
  Future<List<CompanyModel>> getMaterialCompanies({
    int? categoryId,
    bool? isActive,
  });
}

//==-=-=-=-=-=-=-=-=-=-==

class CompaniesRemoteDataSourceImpl implements CompaniesRemoteDataSource {
  final ApiClient apiClient;

  const CompaniesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CompanyModel>> getMaterialCompanies({
    int? categoryId,
    bool? isActive,
  }) async {
    // المعاملات اختيارية حسب الـ API، نمرّر فقط غير الفارغة منها.
    final queryParameters = <String, dynamic>{
      'category': ?categoryId,
      'is_active': ?isActive,
    };

    // الاستجابة مصفوفة JSON بسيطة غير منطّقة.
    final response = await apiClient.getList(
      EndPoint.getMaterialCompanies,
      queryParameters: queryParameters,
      headers: {'Accept-Language': 'ar'},
    );

    return response
        .whereType<Map<String, dynamic>>()
        .map((item) => CompanyModel.fromJson(item))
        .toList();
  }
}
