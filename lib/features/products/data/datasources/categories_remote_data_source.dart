import '../models/categories_response_model.dart';

import '../../../../core/api/network/api_client.dart';
import '../../../../core/api/apiKeys/end_point.dart';

abstract class CategoriesRemoteDataSource {
  Future<CategoriesResponseModel> getCategories();
}

//==-=-=-=-=-=-=-=-=-=-==

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient apiClient;

  const CategoriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CategoriesResponseModel> getCategories() async {
    final response = await apiClient.get(EndPoint.getCategories);

    return CategoriesResponseModel.fromJson(response);
  }
}
