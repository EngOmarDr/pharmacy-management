import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/presentation/pages/login_page.dart';

import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../injection_container.dart';
import '../../pages/home/bloc/home_bloc.dart';
import '../../pages/home/home_page.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  Future<bool> conn(BuildContext context) async {
    await testTokens().then((res) {
      res.fold(
        (l) => false,
        (r) => Navigator.of(context).pushReplacement(
          PageTransition(
            r == null
                ? BlocProvider(
                    create: (_) => sl<LoginBloc>(),
                    child: const LoginPage(),
                  )
                : BlocProvider(
                    create: (_) => sl<HomeBloc>(),
                    child: HomePage(loginModel: r),
                  ),
          ),
        ),
      );
    });
    return true;
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
            ElevatedButton(
                onPressed: () async {
                  conn(context);
                },
                child: FutureBuilder(
                    future: conn(context),
                    builder: (context, snapshot) {
                      print(snapshot.connectionState);
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
