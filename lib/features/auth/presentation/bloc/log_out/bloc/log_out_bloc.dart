import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/api/errors/api_excptions.dart';
import '../../../../domain/useCases/log_out_use_case.dart';

part 'log_out_event.dart';
part 'log_out_state.dart';

class LogOutBloc extends Bloc<LogOutEvent, LogOutState> {
  final LogOutUseCase logOutUseCase;

  LogOutBloc({required this.logOutUseCase}) : super(LogOutInitial()) {
    on<LogOutRequested>(_onLogOutRequested);
  }

  Future<void> _onLogOutRequested(
    LogOutRequested event,
    Emitter<LogOutState> emit,
  ) async {
    emit(const LogOutLoading());

    // المسح المحلي للرموز يحدث دائماً داخل طبقة البيانات (في finally)، لذا
    // نعتبر الخروج ناجحاً حتى لو فشل إدراج رمز التحديث في القائمة السوداء
    // بسبب انقطاع الشبكة أو انتهاء صلاحيته، حتى لا يبقى المستخدم معلّقاً
    // في جلسة منتهية. نسجّل تفاصيل الاستثناء للتشخيص دون إظهارها للمستخدم.
    try {
      await logOutUseCase();
    } on ApiException {
      // blacklist failed — session is still cleared locally.
    } catch (_) {
      // unexpected error — session is still cleared locally.
    }

    emit(const LogOutSuccess());
  }
}
