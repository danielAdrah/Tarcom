// class VerifyOtpResponseEntity {
//   final String message;
//   final AuthTokensEntity tokens;
//   final UserEntity user;

//   const VerifyOtpResponseEntity({
//     required this.message,
//     required this.tokens,
//     required this.user,
//   });
// }

// class AuthTokensEntity {
//   final String access;
//   final String refresh;

//   const AuthTokensEntity({required this.access, required this.refresh});
// }

// class UserEntity {
//   final int id;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String phone;
//   final String? avatar;
//   final String userType;
//   final bool isVerified;

//   const UserEntity({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//     required this.avatar,
//     required this.userType,
//     required this.isVerified,
//   });
// }

import 'auth_tokens_entity.dart';
import 'user_entity.dart';

class VerifyOtpResponseEntity {
  final String message;
  final AuthTokensEntity tokens;
  final UserEntity user;

  const VerifyOtpResponseEntity({
    required this.message,
    required this.tokens,
    required this.user,
  });
}
