import '../../../../core/api/errors/api_excptions.dart';
import '../entities/toggle_favorite_result_entity.dart';
import '../repositories/favorites_repository.dart';

/// حالة استخدام: تبديل حالة المفضلة لمادة معيّنة (إضافة/إزالة).
class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  const ToggleFavoriteUseCase(this.repository);

  Future<ToggleFavoriteResultEntity> call({required int materialId}) async {
    try {
      return await repository.toggleFavorite(materialId: materialId);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
