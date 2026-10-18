part of 'log_out_bloc.dart';

sealed class LogOutState extends Equatable {
  const LogOutState();

  @override
  List<Object> get props => [];
}

final class LogOutInitial extends LogOutState {}

final class LogOutLoading extends LogOutState {
  const LogOutLoading();
}

final class LogOutSuccess extends LogOutState {
  const LogOutSuccess();
}
