import '../../domain/entities/sign_in_response_entity.dart';
import 'auth_tokens_model.dart';
import 'user_model.dart';

class SignInResponseModel extends SignInResponseEntity {
  const SignInResponseModel({required super.tokens, required super.user});

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      tokens: AuthTokensModel.fromJson(
        json['tokens'] as Map<String, dynamic>? ?? {},
      ),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
