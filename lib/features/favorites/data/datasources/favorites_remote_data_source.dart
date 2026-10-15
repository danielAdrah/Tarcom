import '../../../../core/api/apiKeys/end_point.dart';
import '../../../../core/api/network/api_client.dart';
import '../models/favorites_response_model.dart';
import '../models/toggle_favorite_response_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<FavoritesResponseModel> getFavorites({
    String? name,
    String? ordering,
  });

  Future<ToggleFavoriteResponseModel> toggleFavorite({
    required int materialId,
  });
}

//==-=-=-=-=-=-=-=-=-=-==

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final ApiClient apiClient;

  const FavoritesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FavoritesResponseModel> getFavorites({
    String? name,
    String? ordering,
  }) async {
    // المعاملات اختيارية حسب الـ API؛ نمرّر فقط غير الفارغة منها.
    // الترويسة `Authorization: Bearer` تُحقن تلقائياً داخل ApiClient.
    final queryParameters = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
    };

    final response = await apiClient.get(
      EndPoint.getFavorites,
      queryParameters: queryParameters,
      headers: {'Accept-Language': 'ar'},
    );

    return FavoritesResponseModel.fromJson(response);
  }

  @override
  Future<ToggleFavoriteResponseModel> toggleFavorite({
    required int materialId,
  }) async {
    final response = await apiClient.post(
      EndPoint.toggleFavorite,
      body: {'material': materialId},
      headers: {'Accept-Language': 'ar'},
    );

    return ToggleFavoriteResponseModel.fromJson(response);
  }
}
