import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/features/home/bloc/home_bloc.dart';
import 'package:dashboard/features/home/home_page.dart';
import 'package:dashboard/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/auth/presentation/bloc/login_bloc.dart';

import '../widgets/my_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    print('========== Build login page ==========');
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is ErrorLoginState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'error'.tr(),
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        } else if (state is FinishGetDataState) {
          print(state.loginModel);
          Navigator.of(context).pushReplacement(
            PageTransition(
              BlocProvider(
                create: (context) => sl<HomeBloc>(),
                child: HomePage(loginModel: state.loginModel),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: MyForm(bloc: bloc))),
      ),
    );
  }
}
