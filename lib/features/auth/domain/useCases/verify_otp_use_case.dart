import '../../../../core/api/errors/api_excptions.dart';
import '../entities/verify_otp_response_entity.dart';
import '../repostories/auth_repo.dart';

class VerifyOtpParams {
  final String email;
  final int code;
  final String codeType;

  const VerifyOtpParams({
    required this.email,
    required this.code,
    required this.codeType,
  });
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  Future<VerifyOtpResponseEntity> call(VerifyOtpParams params) async {
    try {
      return await repository.verifyOtp(
        email: params.email,
        code: params.code,
        codeType: params.codeType,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
