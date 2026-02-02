import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this.fs) : super(ThemeInitial());

  final FlutterSecureStorage fs;

  static late AdaptiveThemeMode theme;

  static Future<void> getIsDark() async {
    String? result = await sl<FlutterSecureStorage>().read(key: 'isDark');
    if (result == null) {
      theme = AdaptiveThemeMode.system ;
    } else {
      theme = result.toLowerCase() == 'true' ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light;
    }
  }
}
