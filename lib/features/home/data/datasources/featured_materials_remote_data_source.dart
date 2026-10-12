import '../models/featured_materials_response_model.dart';

import '../../../../core/api/network/api_client.dart';
import '../../../../core/api/apiKeys/end_point.dart';

abstract class FeaturedMaterialsRemoteDataSource {
  Future<FeaturedMaterialsResponseModel> getFeaturedMaterials({
    int? page,
    int? pageSize,
    int? category,
    String? company,
    bool? isActive,
    String? search,
    String? ordering,
  });
}

//==-=-=-=-=-=-=-=-=-=-==

class FeaturedMaterialsRemoteDataSourceImpl
    implements FeaturedMaterialsRemoteDataSource {
  final ApiClient apiClient;

  const FeaturedMaterialsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FeaturedMaterialsResponseModel> getFeaturedMaterials({
    int? page,
    int? pageSize,
    int? category,
    String? company,
    bool? isActive,
    String? search,
    String? ordering,
  }) async {
    // المعاملات اختيارية حسب الـ API، نمرّر فقط غير الفارغة منها.
    final queryParameters = <String, dynamic>{
      'page': ?page,
      'page_size': ?pageSize,
      'category': ?category,
      'is_active': ?isActive,
      if (company != null && company.isNotEmpty) 'company': company,
      if (search != null && search.isNotEmpty) 'search': search,
      if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
    };

    final response = await apiClient.get(
      EndPoint.getFeaturedMaterials,
      queryParameters: queryParameters,
      headers: {'Accept-Language': 'ar'},
    );

    return FeaturedMaterialsResponseModel.fromJson(response);
  }
}
