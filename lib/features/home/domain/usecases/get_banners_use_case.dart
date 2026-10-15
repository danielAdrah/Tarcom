import '../../../../core/api/errors/api_excptions.dart';
import '../entities/banner_entity.dart';
import '../repositories/banners_repository.dart';

class GetBannersUseCase {
  final BannersRepository repository;

  const GetBannersUseCase(this.repository);

  Future<List<BannerEntity>> call() async {
    try {
      return await repository.getBanners();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
