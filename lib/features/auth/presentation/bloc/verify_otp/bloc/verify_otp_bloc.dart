import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/api/errors/api_excptions.dart';
import '../../../../domain/entities/verify_otp_response_entity.dart';
import '../../../../domain/useCases/verify_otp_use_case.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpBloc({required this.verifyOtpUseCase}) : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<VerifyOtpReset>(_onVerifyOtpReset);
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    try {
      final response = await verifyOtpUseCase(
        VerifyOtpParams(
          email: event.email,
          code: event.code,
          codeType: event.codeType,
        ),
      );

      emit(VerifyOtpSuccess(response: response));
    } on ApiException catch (e) {
      emit(VerifyOtpFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const VerifyOtpFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'),
      );
    }
  }

  void _onVerifyOtpReset(VerifyOtpReset event, Emitter<VerifyOtpState> emit) {
    emit(VerifyOtpInitial());
  }
}
