import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../models/login_model.dart';

abstract class AuthRemoteSource {
  Future<LoginModel> login(String email, String password);

  Future<void> changePassword(
      String currentPass, String newPass, String reNewPass);

  Future<String> refreshToken(LoginModel? loginModel);

  Future<void> verifyToken(String accessToken);

  Future<void> registerDevice(int pharmacyID,String token);
}

class AuthRemoteSourceImpl1 implements AuthRemoteSource {
  @override
  Future<LoginModel> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.http(domain(), '/api/auth/jwt/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar'
      },
      body: json.encode({'email': email, 'password': password}),
    );

    print('response status : ${response.statusCode}');
    print('response body : ${response.body}');
    if (response.statusCode == 200) {
      LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
      return loginModel;
    } else if (response.statusCode == 401) {
      throw DataNotCompleteException(
          myDecode(bodyBytes: response.bodyBytes, data: 'detail'));
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'detail'));
    }
  }

  @override
  Future<void> changePassword(
      String currentPass, String newPass, String reNewPass) async {
    throw UnimplementedError();

    // http.Response response = await http.post(
    //   Uri.http(domain(), '/api/auth/users/set_password/'),
    //   headers: {
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     HttpHeaders.acceptLanguageHeader: 'en-us',
    //   },
    //   body: {
    //     'new_password' : newPass,
    //     're_new_password' : reNewPass,
    //     'current_password' : currentPass,
    //   },
    // );
    //
    // print('response status : ${response.statusCode}');
    // print('response body : ${response.body}');
    //
    // if (response.statusCode == 204) {
    //   return ;
    // } else {
    //   throw DetailsException(
    //       myDecode(bodyBytes: response.bodyBytes, data: 'detail'));
    // }
  }

  @override
  Future<String> refreshToken(LoginModel? loginModel) async {
    http.Response response = await http.post(
      Uri.http(domain(), '/api/auth/jwt/refresh'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar'
      },
      body: json.encode({'refresh': loginModel!.tokens.refresh}),
    );

    print('response status : ${response.statusCode}');
    print('response body : ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body)['access'].toString();
    } else {
      throw TokensNotValidException();
    }
  }

  @override
  Future<void> verifyToken(String accessToken) async {
    http.Response response = await http.post(
      Uri.http(domain(), '/api/auth/jwt/verify/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar'
      },
      body: json.encode({'token': accessToken}),
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else {
      throw AccessNotValidException();
    }
  }

  @override
  Future<void> registerDevice(int pharmacyID,String token) async {

    String androidId = await UniqueIdentifier.serial ?? '';
    print(androidId);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('=--=${fcmToken!}----');
    http.Response response = await http.post(
      Uri.http(domain(), '/api/devices/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'en-en',
        'Authorization': 'Bearer $token'
      },
      body: {
        'name': '1',
        'registration_id':fcmToken,
        'device_id': androidId,
        'active':'true',
        'type':'android',
      },
    );

    print('response status : ${response.statusCode}');
    print('response body : ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      return;
      // throw DetailsException(myDecode(bodyBytes: response.bodyBytes,data: 'errors'));
    }
  }
}
