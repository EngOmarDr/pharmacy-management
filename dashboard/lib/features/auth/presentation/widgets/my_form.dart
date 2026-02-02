import 'package:dashboard/core/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/utils/my_text_field_widget.dart';
import 'package:dashboard/features/auth/presentation/bloc/login_bloc.dart';

class MyForm extends StatelessWidget {
  const MyForm({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: bloc.formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: mPadding),
        children: [
          const Image(
            image: AssetImage('assets/images/logo.png'),
          ),
          MyTextField(
            keyType: TextInputType.emailAddress,
            controller: bloc.email,
            lText: 'e_email'.tr(),
            preIcon: const Icon(Icons.email),
          ),
          const SizedBox(height: 15),
          BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                current is ChangeObscurePasswordState,
            builder: (context, state) {
              print('---------- Build Password Field ----------');
              return MyTextField(
                obText: bloc.isObscure,
                controller: bloc.password,
                lText: 'e_password'.tr(),
                preIcon: const Icon(Icons.lock),
                sufIcon: IconButton(
                  onPressed: () => bloc.add(ChangeObscurePasswordEvent()),
                  icon: bloc.isObscure
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          FilledButton(
            onPressed: () => bloc.add(SendDataEvent()),
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  current is StartGetDataState || previous is StartGetDataState,
              builder: (context, state) {
                print('---------- Build Child Elevated ----------');
                return state is! StartGetDataState
                    ? const Text('in_submit').tr()
                    : const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
