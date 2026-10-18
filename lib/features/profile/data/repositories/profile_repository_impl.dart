import '../../../../core/api/errors/api_excptions.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserProfileEntity> getUserProfile() async {
    try {
      final UserProfileModel profile = await remoteDataSource.getUserProfile();
      // نجاح الشبكة: نحدّث النسخة المحفوظة للوضع دون اتصال.
      await localDataSource.cacheProfile(profile);
      return profile;
    } on ApiException {
      // تعذّرت الشبكة: نعرض آخر نسخة محفوظة إن وُجدت قبل إشعار المستخدم (stale).
      final UserProfileModel? cached = localDataSource.getCachedProfile();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<UserProfileEntity> updateUserProfile(
    UpdateProfileParams params,
  ) async {
    // التحديث عملية كتابة: لا نرجع للنسخة المخزّنة عند الفشل، بل نرفع الخطأ
    // ليصل إلى المستخدم (تعذّر الاتصال/تحقق الحقول/انتهاء الصلاحية).
    final UserProfileModel updated = await remoteDataSource.updateUserProfile(
      params,
    );
    // نجاح: نحدّث النسخة المحفوظة ليعكس الوضع دون الاتصال آخر بيانات.
    await localDataSource.cacheProfile(updated);
    return updated;
  }
}
