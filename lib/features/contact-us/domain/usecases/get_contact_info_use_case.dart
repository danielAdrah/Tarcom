import '../../../../core/api/errors/api_excptions.dart';
import '../entities/contact_info_entity.dart';
import '../repositories/contact_info_repository.dart';

class GetContactInfoUseCase {
  final ContactInfoRepository repository;

  const GetContactInfoUseCase(this.repository);

  Future<ContactInfoEntity> call() async {
    try {
      return await repository.getContactInfo();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
