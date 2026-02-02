import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_local_source.dart';

import '../features/auth/data/models/login_model.dart';
import '../features/auth/domain/repositories/auth_repo.dart';
import '../injection_container.dart';
import 'error/failures.dart';

MaterialColor primaryColor = Colors.green;
const double mPadding = 20;

String domain1 = '192.168.1.108:8000';
String domain2 = '192.168.1.106:8000';
String domain3 = '127.0.0.1:8000';
String domain4 = '10.0.2.2:8000';
String domain5 = '192.168.100.200:8000';

String domain() => domain5;

const String loginStorageKey = 'loginModal';

bool isWindows() => Platform.isWindows;

String myDecode({required Uint8List bodyBytes, String? data}) {
  final String res = data == null
      ? jsonDecode(utf8.decode(bodyBytes))
      : jsonDecode(utf8.decode(bodyBytes))[data];
  print(res);
  return res;
}

String toArabic(Uint8List bodyBytes) {
  return jsonDecode(utf8.decode(bodyBytes));
}

String? nullValidate(String? text) {
  switch (text) {
    case null:
      return "can't be empty";
    case '':
      return "can't be empty";
  }
  return null;
}

Widget reqField(BuildContext context, String text) {
  return RichText(
    text: TextSpan(
        text: text,
        style: Theme.of(context).inputDecorationTheme.labelStyle,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700),
          )
        ]),
  );
}

Future myAwesomeDlg(
    {required BuildContext context,
    required String message,
    required String title,
    required DialogType type,
    void Function()? ok}) async {
  await AwesomeDialog(
    context: context,
    width: Platform.isWindows ? MediaQuery.of(context).size.width / 2 : null,
    dialogType: type,
    title: title,
    desc: message,
    btnOkOnPress: () {
      ok;
    },
  ).show();
}

Future<Either<bool, LoginModel?>> testTokens() async {
  final loginModel = await sl<AuthLocalSource>().getStoreData();
  print(loginModel?.tokens.access);
  if (loginModel == null) {
    return const Right(null);
  }

  final res = await sl<AuthRepo>().verifyToken();
  return res.fold((failure) {
    print(failure);
    if (failure.runtimeType is LoginFailure) {
      return const Right(null);
    } else {
      return const Left(false);
    }
  }, (r) => Right(loginModel));
}

final ThemeData themeLight = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // fillColor: Colors.grey[200],
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green, width: 2)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green, width: 2)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2)),
    prefixIconColor: Colors.green,
    labelStyle: const TextStyle(
      color: Colors.black,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(40)),
  ),
  // progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
);
