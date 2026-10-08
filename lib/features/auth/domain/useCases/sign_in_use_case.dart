import '../../../../core/api/errors/api_excptions.dart';
import '../entities/sign_in_response_entity.dart';
import '../repostories/auth_repo.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUseCase {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  Future<SignInResponseEntity> call(SignInParams params) async {
    try {
      return await repository.signIn(
        email: params.email,
        password: params.password,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
