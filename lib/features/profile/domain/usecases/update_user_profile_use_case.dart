import '../../../../core/api/errors/api_excptions.dart';
import '../entities/update_profile_params.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// حالة استخدام تحديث الملف الشخصي للمستخدم الموثّق.
class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  const UpdateUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call(UpdateProfileParams params) async {
    try {
      return await repository.updateUserProfile(params);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
