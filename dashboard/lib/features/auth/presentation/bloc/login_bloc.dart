import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/auth/domain/useCases/login_usecase.dart';

import '../../data/models/login_model.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
          (loginModel) => emit(FinishGetDataState(loginModel)),
        );
      }
    });
  }

  String _failureType(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'email or password error';
      case OfflineFailure:
        return 'no internet connection';
      case CacheFailure:
        return 'cache error try again';
      case DetailsFailure:
        failure as DetailsFailure;
        return failure.error;
      default:
        return 'Unknown Error';
    }
  }


}
