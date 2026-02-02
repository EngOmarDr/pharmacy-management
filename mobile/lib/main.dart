import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/pages/home/home_page.dart';

import 'core/constant.dart';
import 'core/utils/no_internet_page.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart';
import 'pages/home/bloc/home_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setup();
  final d = await testTokens();
  d.fold(
    (isConnect) => runApp(
      MyApp(isConnect: isConnect),
    ),
    (logM) => runApp(
      MyApp(logM: logM),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.logM, this.isConnect = true});

  final LoginModel? logM;
  final bool isConnect;

  StatelessWidget getHomeWidget(BuildContext context) {
    return !isConnect
        ? const NoInternetPage()
        : logM == null
            ? BlocProvider(
                create: (_) => sl<LoginBloc>(),
                child: const LoginPage(),
              )
            : BlocProvider(
                create: (_) => sl<HomeBloc>(),
                child: HomePage(loginModel: logM!),
              );
  }

  @override
  Widget build(BuildContext context) {
    log('----------------------');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy Management',
      theme: themeLight,
      home: BlocProvider(
        create: (context) => sl<HomeBloc>(),
        child: home(),
      ),
    );
  }

  StatelessWidget home() {
    return !isConnect
        ? const NoInternetPage()
        : logM == null
            ? BlocProvider<LoginBloc>(
                create: (_) => sl<LoginBloc>(),
                child: const LoginPage(),
              )
            : BlocProvider<HomeBloc>(
                create: (_) => sl<HomeBloc>(),
                child: HomePage(loginModel: logM!),
              );
  }
}
