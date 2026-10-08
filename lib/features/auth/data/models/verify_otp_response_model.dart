import '../../domain/entities/verify_otp_response_entity.dart';

class VerifyOtpResponseModel extends VerifyOtpResponseEntity {
  const VerifyOtpResponseModel({
    required super.message,
    required super.tokens,
    required super.user,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      message: json['message'] as String? ?? '',
      tokens: AuthTokensModel.fromJson(
        json['tokens'] as Map<String, dynamic>? ?? {},
      ),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({required super.access, required super.refresh});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      access: json['access'] as String? ?? '',
      refresh: json['refresh'] as String? ?? '',
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.avatar,
    required super.userType,
    required super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String?,
      userType: json['user_type'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }
}
