part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

final class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  final VerifyOtpResponseEntity response;

  const VerifyOtpSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class VerifyOtpFailure extends VerifyOtpState {
  final String message;
  final ApiException? exception;

  const VerifyOtpFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
