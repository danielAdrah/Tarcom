import 'package:equatable/equatable.dart';

/// معاملات تحديث الملف الشخصي عبر `PUT /api/users/me/`.
///
/// الحقول المسموح بتعديلها: `first_name` و`last_name` و`phone`
/// (البريد الإلكتروني والصورة الشخصية خارج نطاق هذا التحديث حالياً).
class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object> get props => [firstName, lastName, phone];
}
