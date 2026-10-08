import '../../domain/entities/auth_tokens_entity.dart';

class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({required super.access, required super.refresh});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      access: json['access'] as String? ?? '',
      refresh: json['refresh'] as String? ?? '',
    );
  }
}
