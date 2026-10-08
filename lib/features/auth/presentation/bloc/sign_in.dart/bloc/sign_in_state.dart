part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {
  const SignInLoading();
}

class SignInSuccess extends SignInState {
  final SignInResponseEntity response;

  const SignInSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class SignInFailure extends SignInState {
  final String message;
  final ApiException? exception;

  const SignInFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
