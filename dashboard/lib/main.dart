import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constant.dart';
import 'core/theme_cubit/theme_cubit.dart';
import 'core/utils/no_internet_page.dart';
import 'features/auth/data/models/login_model.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/home/home_page.dart';
import 'injection_container.dart';
import 'observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await setup();

  await ThemeCubit.getIsDark();

  final d = await testTokens();
  d.fold(
    (isConnect) => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        fallbackLocale: const Locale('en'),
        child: BlocProvider(
          create: (_) => ThemeCubit(sl()),
          child: MyApp(isConnect: isConnect),
        ),
      ),
    ),
    (logM) => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        fallbackLocale: const Locale('en'),
        child: BlocProvider(
          create: (_) => ThemeCubit(sl()),
          child: MyApp(logM: logM),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isConnect = true, this.logM});

  final bool isConnect;
  final LoginModel? logM;

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
    print('****************** Build Main ********************');
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AdaptiveTheme(
          initial: ThemeCubit.theme,
          light: lightTheme,
          dark: darkTheme,
          builder:(light, dark) => MaterialApp(
            title: "title".tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            home: getHomeWidget(context),
          ),
        );
      },
    );
  }
}
