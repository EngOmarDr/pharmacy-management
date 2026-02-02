import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/error/exceptions.dart';

import '../../domain/entities/company.dart';
import '../models/company_model.dart';

abstract class CompanyRemoteSource {
  Future<Company> createCompany(CompanyModel company, String accessToken);

  Future<Company> updateCompany(
      CompanyModel pharmacy, int companyId, String accessToken);

  Future<void> deleteCompany(int companyId, String accessToken);

  Future<Company> companyDetail(int companyId, String accessToken);

  Future<List<Company>> listCompanies(String accessToken);
}

class CompanyRemoteSourceImpl1 implements CompanyRemoteSource {
  @override
  Future<Company> createCompany(
      CompanyModel companyModel, String accessToken) async {
    final response = await http.post(
      Uri.http(domain(), '/api/company/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: companyModel.toJson(),
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }

  @override
  Future<Company> companyDetail(int companyId, String accessToken) async {
    final response = await http.delete(
      Uri.http(domain(), '/api/company/$companyId/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> deleteCompany(int companyId, String accessToken) async {
    final response = await http.delete(
      Uri.http(domain(), '/api/company/$companyId/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 403) {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'error'));
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<List<Company>> listCompanies(String accessToken) async {
    final response = await http.get(
      Uri.http(domain(), '/api/company/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print('response status : ${response.statusCode}');
    print(
        'response status : ${response.body} ${json.decode(response.body).runtimeType}');
    if (response.statusCode == 200) {
      List temp = json.decode(response.body);
      List<Company> allComp = [];
      for (var element in temp) {
        allComp.add(Company.fromJson(element));
      }
      return allComp;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<Company> updateCompany(
      CompanyModel company, int companyId, String accessToken) async {
    print(companyId);
    final response =
        await http.put(Uri.http(domain(), '/api/company/$companyId/'),
            headers: {
              HttpHeaders.acceptLanguageHeader: 'ar-ar',
              HttpHeaders.authorizationHeader: 'Bearer $accessToken'
            },
            body: company.toJson());

    print('response status : ${response.statusCode} 44444444');
    if (response.statusCode == 200) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }
}
