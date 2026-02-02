part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class ChangeObscurePasswordEvent extends LoginEvent {}

class SendDataEvent extends LoginEvent {}
