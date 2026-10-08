part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpSuccess extends SignUpState {
  final SignUpEntity response;
  final String email;

  const SignUpSuccess({required this.response, required this.email});

  @override
  List<Object> get props => [response, email];
}

class SignUpFailure extends SignUpState {
  final String message;
  final ApiException? exception;

  const SignUpFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
