import '../../domain/entities/sign_up_entity.dart';

class SignUpResponseModel extends SignUpEntity {
  const SignUpResponseModel({
    required super.message,
    required super.email,
    required super.emailSent,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      message: json['message'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailSent: json['email_sent'] as bool? ?? false,
    );
  }
}
