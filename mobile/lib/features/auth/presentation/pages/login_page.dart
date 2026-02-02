import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/presentation/bloc/login_bloc.dart';
import 'package:pharmacy/features/auth/presentation/widgets/my_form.dart';
import 'package:pharmacy/injection_container.dart';
import 'package:pharmacy/pages/home/bloc/home_bloc.dart';
import 'package:pharmacy/pages/home/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    print('========== Build login page ==========');
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is ErrorLoginState) {
          myAwesomeDlg(
            context: context,
            type: DialogType.error,
            title: 'error',
            message: state.message,
          );
        } else if (state is FinishGetDataState) {
          Navigator.of(context).pushReplacement(
            PageTransition(BlocProvider(
              create: (context) => sl<HomeBloc>(),
              child: HomePage(loginModel: state.logM),
            )),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: MyForm(bloc: bloc),
          ),
        ),
      ),
    );
  }
}
