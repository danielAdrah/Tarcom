import '../../../../core/api/errors/api_excptions.dart';
import '../entities/sign_up_entity.dart';
import '../repostories/auth_repo.dart';

class SignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
  });
}

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<SignUpEntity> call(SignUpParams params) async {
    try {
      return await repository.signUp(
        email: params.email,
        password: params.password,
        firstName: params.firstName,
        lastName: params.lastName,
        phone: params.phone,
        userType: params.userType,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownApiException();
    }
  }
}
