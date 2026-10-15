import '../models/banner_model.dart';

import '../../../../core/api/network/api_client.dart';
import '../../../../core/api/apiKeys/end_point.dart';

abstract class BannersRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

//==-=-=-=-=-=-=-=-=-=-==

class BannersRemoteDataSourceImpl implements BannersRemoteDataSource {
  final ApiClient apiClient;

  const BannersRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BannerModel>> getBanners() async {
    // الاستجابة مصفوفة JSON بسيطة غير منطّقة.
    final response = await apiClient.getList(
      EndPoint.getBanners,
      headers: {'Accept-Language': 'ar'},
    );

    return response
        .whereType<Map<String, dynamic>>()
        .map((item) => BannerModel.fromJson(item))
        .toList();
  }
}
