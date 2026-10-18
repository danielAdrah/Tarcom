part of 'log_out_bloc.dart';

sealed class LogOutEvent extends Equatable {
  const LogOutEvent();

  @override
  List<Object> get props => [];
}

final class LogOutRequested extends LogOutEvent {
  const LogOutRequested();
}
