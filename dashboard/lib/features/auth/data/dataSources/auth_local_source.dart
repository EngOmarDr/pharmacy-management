import 'dart:convert';

import 'package:dashboard/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constant.dart';
import '../models/login_model.dart';

abstract class AuthLocalSource {
  Future<LoginModel?> getStoreData();
  Future<void> storeAuthData(LoginModel loginModel);
  Future<void> deleteAuthData();
}

class AuthLocalSourceImpl1 implements AuthLocalSource {
  final FlutterSecureStorage secureStorage ;

  AuthLocalSourceImpl1({required this.secureStorage});

  @override
  Future<LoginModel?> getStoreData() async{
    final String? jsonString = await secureStorage.read(key: loginStorageKey);
    if(jsonString != null){
      return LoginModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<bool> storeAuthData(LoginModel loginModel) async {
    try {
      await secureStorage.write(
          key: loginStorageKey, value: jsonEncode(loginModel));
      return true;
    }catch(e){
      print(e);
      throw CacheException();
    }
  }

  @override
  Future<void> deleteAuthData() async {
    try {
      await secureStorage.delete(key: loginStorageKey);
    }catch(e){
      print(e);
      throw CacheException();
    }
  }

}