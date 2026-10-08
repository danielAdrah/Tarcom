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
}
