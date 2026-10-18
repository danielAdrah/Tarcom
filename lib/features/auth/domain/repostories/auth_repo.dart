import '../entities/auth_tokens_entity.dart';
import '../entities/sign_in_response_entity.dart';
import '../entities/sign_up_entity.dart';
import '../entities/verify_otp_response_entity.dart';

abstract class AuthRepository {
  Future<SignUpEntity> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String userType,
  });

  Future<VerifyOtpResponseEntity> verifyOtp({
    required String email,
    required int code,
    required String codeType,
  });

  Future<SignInResponseEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> logout();

  /// يستبدل رمز الوصول منتهي الصلاحية برمز جديد باستخدام رمز التحديث
  /// المخزّن محلياً. يُرجع الرمز الجديد ويُحدّث المخزن داخل طبقة البيانات.
  Future<AuthTokensEntity> refreshToken();
}
