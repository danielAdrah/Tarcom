part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final int code;
  final String codeType;

  const VerifyOtpSubmitted({
    required this.email,
    required this.code,
    required this.codeType,
  });

  @override
  List<Object> get props => [email, code, codeType];
}

class VerifyOtpReset extends VerifyOtpEvent {
  const VerifyOtpReset();
}
