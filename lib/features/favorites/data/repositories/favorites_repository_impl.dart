import '../../domain/entities/favorites_response_entity.dart';
import '../../domain/entities/toggle_favorite_result_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  const FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FavoritesResponseEntity> getFavorites({
    String? name,
    String? ordering,
  }) async {
    return await remoteDataSource.getFavorites(name: name, ordering: ordering);
  }

  @override
  Future<ToggleFavoriteResultEntity> toggleFavorite({
    required int materialId,
  }) async {
    return await remoteDataSource.toggleFavorite(materialId: materialId);
  }
}
