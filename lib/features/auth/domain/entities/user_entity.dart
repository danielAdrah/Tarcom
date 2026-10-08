class UserEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? avatar;
  final String userType;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.avatar,
    required this.userType,
    required this.isVerified,
  });
}
