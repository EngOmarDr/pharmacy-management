import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/error/exceptions.dart';

import '../models/pharmacy_model.dart';

abstract class PharmacyRemoteSource {
  Future<void> createPharmacy(PharmacyModel pharmacy, String accessToken);

  Future<void> updatePharmacy(
      PharmacyModel pharmacy, int pharmacyId, String accessToken);

  Future<void> deletePharmacy(int pharmacyId, String accessToken);

  Future<void> pharmacyDetail(int pharmacyId, String accessToken);

  Future<List<dynamic>> allPharmacies(String accessToken);
}

class PharmacyRemoteSourceImpl1 implements PharmacyRemoteSource {
  @override
  Future<void> createPharmacy(
      PharmacyModel pharmacy, String accessToken) async {
    final response = await http.post(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: json.encode(pharmacy.toJson()),
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> deletePharmacy(int pharmacyId, String accessToken) async {
    final response = await http.delete(
      Uri.http(domain(), '/api/pharmacy/$pharmacyId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 204) {
      return;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> pharmacyDetail(int pharmacyId, String accessToken) async {
    final response = await http.delete(
      Uri.http(domain(), '/api/pharmacy/$pharmacyId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> updatePharmacy(
      PharmacyModel pharmacy, int pharmacyId, String accessToken) async {
    final response = await http.put(
      Uri.http(domain(), '/api/pharmacy/$pharmacyId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<List<dynamic>> allPharmacies(String accessToken) async {
      final response = await http.get(
        Uri.http(domain(), '/api/pharmacy/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      print('response status : ${response.statusCode}');
      print('response status : ${ response.body} ${json.decode(response.body).runtimeType}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ServerErrorException();
      }
    }

}
