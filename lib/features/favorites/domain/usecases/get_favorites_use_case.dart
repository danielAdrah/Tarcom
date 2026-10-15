import '../../../../core/api/errors/api_excptions.dart';
import '../entities/favorites_response_entity.dart';
import '../repositories/favorites_repository.dart';

/// حالة استخدام: جلب قائمة المفضلة للمستخدم المسجّل.
class GetFavoritesUseCase {
  final FavoritesRepository repository;

  const GetFavoritesUseCase(this.repository);

  Future<FavoritesResponseEntity> call({String? name, String? ordering}) async {
    try {
      return await repository.getFavorites(name: name, ordering: ordering);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
