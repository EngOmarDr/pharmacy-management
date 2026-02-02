import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';
import 'package:flutter/material.dart';
import '../features/auth/data/dataSources/auth_local_source.dart';
import '../features/auth/domain/repositories/auth_repo.dart';
import '../injection_container.dart';


String domain1 = '192.168.1.104:8000';
String domain2 = '192.168.1.108:8000';
String domain3 = '127.0.0.1:8000';
String domain4 = '10.0.2.2:8000';
String domain5 = '192.168.100.151:8000';

String domain() => domain5;

const String loginStorageKey = 'loginModal';

const double mPadding = 20;

String myDecode({required Uint8List bodyBytes, String? data}) {
  final String res = data == null
      ? jsonDecode(utf8.decode(bodyBytes))
      : jsonDecode(utf8.decode(bodyBytes))[data];
  return res;
}

dynamic toArabic({required Uint8List bodyBytes}) {
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

final darkTheme = ThemeData.dark(
  useMaterial3: true,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
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
  fontFamily: 'Mogra',
  // progressIndicatorTheme: const ProgressIndicatorThemeData(
  //   color: Colors.white
  // ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(40)),
  ),
  // progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
);
