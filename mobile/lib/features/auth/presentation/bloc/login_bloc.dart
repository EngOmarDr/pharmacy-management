import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/auth/domain/useCases/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isObscure = true;

  final LoginUseCase login;

  LoginBloc({required this.login}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is ChangeObscurePasswordEvent) {
        isObscure = !isObscure;
        emit(ChangeObscurePasswordState());
      } else if (event is SendDataEvent) {
        if (!formKey.currentState!.validate()) {
          return;
        }
        emit(StartGetDataState());
        final res = await login(email.text, password.text);
        res.fold(
          (failure) => emit(ErrorLoginState(_failureType(failure))),
          (type) => emit(FinishGetDataState(type)),
        );
      }
    });
  }

  String _failureType(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'server error';
      case OfflineFailure:
        return 'no internet connection';
      case CacheFailure:
        return 'cache error try again';
      case DataNotCompleteFailure:
        failure as DataNotCompleteFailure;
        return failure.message;
      default:
        return 'Unknown Error';
    }
  }
}
