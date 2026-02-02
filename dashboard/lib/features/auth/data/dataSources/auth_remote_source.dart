import 'dart:convert';
import 'dart:io';

import 'package:dashboard/core/constant.dart';
import 'package:dashboard/features/shift/domain/entities/shift.dart';
import 'package:http/http.dart' as http;
import 'package:dashboard/core/error/exceptions.dart';
import '../models/login_model.dart';

abstract class AuthRemoteSource {
  Future<LoginModel> login(String email, String password);

  Future<void> changePassword(
      String currentPass, String newPass, String reNewPass);

  Future<String> refreshToken(LoginModel? loginModel);

  Future<void> verifyToken(String accessToken);
}

class AuthRemoteSourceImpl1 implements AuthRemoteSource {
  @override
  Future<LoginModel> login(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.http(domain(), '/api/auth/jwt/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // HttpHeaders.acceptLanguageHeader: 'ar-ar'
        },
        body: json.encode({'email': email, 'password': password}),
      );

      print('response status : ${response.statusCode} from login');
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
        print("${loginModel.type != Role.manager.value} + ${loginModel.type !=
            Role.pharmacyManager.value} ${loginModel.type}");
        if(loginModel.type != Role.manager.value && loginModel.type != Role.pharmacyManager.value) throw ServerErrorException();
        return loginModel;
      } else if (response.statusCode == 401) {
        throw DetailsException(detail:
            myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
      } else {
        throw ServerErrorException();
      }
    }catch(e){
      print('$e');
      throw ServerErrorException();
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

    print('response status : ${response.statusCode} from refresh token');
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

    print('response status : ${response.statusCode} from verify');
    if (response.statusCode == 200) {
      return;
    } else {
      throw AccessNotValidException();
    }
  }
}
