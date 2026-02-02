part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class ChangeObscurePasswordState extends LoginState {}

class StartGetDataState extends LoginState {}

class FinishGetDataState extends LoginState {
  final LoginModel logM;

  FinishGetDataState(this.logM);
}

class ErrorLoginState extends LoginState {
  final String message;

  ErrorLoginState(this.message);
}

