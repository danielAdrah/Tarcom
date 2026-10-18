import '../entities/update_profile_params.dart';
import '../entities/user_profile_entity.dart';

/// عقد الملف الشخصي للمستخدم الموثّق: الجلب والتحديث.
abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();

  /// تحديث كامل عبر `PUT /api/users/me/` ويُرجع الملف المحدَّث.
  Future<UserProfileEntity> updateUserProfile(UpdateProfileParams params);
}
