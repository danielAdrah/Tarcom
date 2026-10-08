import 'auth_tokens_entity.dart';
import 'user_entity.dart';

class SignInResponseEntity {
  final AuthTokensEntity tokens;
  final UserEntity user;

  const SignInResponseEntity({required this.tokens, required this.user});
}
