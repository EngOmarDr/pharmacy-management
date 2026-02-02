import 'package:dashboard/features/home/bloc/home_bloc.dart';
import 'package:dashboard/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../injection_container.dart';
import '../constant.dart';
import '../page_transition.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  Future<bool> conn(BuildContext context) async {
    await testTokens().then((res) {
      print('$res form test tokens no internet page');
      res.fold((l) {
        return false;
      }, (loginModel) {
        Navigator.of(context).pushReplacement(PageTransition(
          loginModel == null
              ? const LoginPage()
              : BlocProvider(
            create: (context) => sl<HomeBloc>(),
            child: HomePage(loginModel: loginModel),
          ),
        ));
      });
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 40),
            const Text(
              'no internet connection',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
                onPressed: () async {
                  conn(context);
                },
                child: FutureBuilder(
                    future: conn(context),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : const Text('Retry');
                    }))
          ],
        ),
      ),
    );
  }
}
