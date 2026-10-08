part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;

  const SignUpSubmitted({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
  });

  @override
  List<Object> get props => [
    email,
    password,
    firstName,
    lastName,
    phone,
    userType,
  ];
}

class SignUpReset extends SignUpEvent {
  const SignUpReset();
}
