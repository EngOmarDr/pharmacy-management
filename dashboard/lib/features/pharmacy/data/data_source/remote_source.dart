import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dashboard/core/constant.dart';
import 'package:dashboard/core/error/exceptions.dart';

import '../../domain/entities/pharmacy.dart';
import '../models/pharmacy_model.dart';

abstract class PharmacyRemoteSource {
  Future<void> createPharmacy(PharmacyModel pharmacy, String accessToken);

  Future<void> updatePharmacy(PharmacyModel pharmacy, String accessToken);

  Future<void> deletePharmacy(int pharmacyId, String accessToken);

  Future<List<Pharmacy>> pharmacyDetail(int pharmacyId, String accessToken);

  Future<List<Pharmacy>> allPharmacies(String accessToken);
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
    } else if (response.statusCode == 400) {
      throw DetailsException(detail:
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
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
  Future<List<Pharmacy>> pharmacyDetail(
      int pharmacyId, String accessToken) async {
    // final response = await http.delete(
    //   Uri.http(domain(), '/api/pharmacy/$pharmacyId/'),
    //   headers: {
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     HttpHeaders.acceptLanguageHeader: 'ar-ar',
    //     HttpHeaders.authorizationHeader: 'Bearer $accessToken'
    //   },
    // );
    //
    // print('response status : ${response.statusCode}');
    // print('response status : ${utf8.decode(response.bodyBytes)}');
    // if (response.statusCode == 200) {
    //   List<PharmacyModel> result = [
    //     PharmacyModel.formJson(toArabic(bodyBytes: response.bodyBytes))
    //   ];
    //   return result;
    // } else {
    //   throw ServerErrorException();
    // }
    throw UnimplementedError();
  }

  @override
  Future<void> updatePharmacy(
      PharmacyModel pharmacy, String accessToken) async {
    final response =
        await http.put(Uri.http(domain(), '/api/pharmacy/${pharmacy.id}/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              // HttpHeaders.acceptLanguageHeader: 'ar-ar',
              HttpHeaders.authorizationHeader: 'Bearer $accessToken'
            },
            body: jsonEncode(pharmacy.toJson()));

    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<List<Pharmacy>> allPharmacies(String accessToken) async {
    final response = await http.get(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    print('response status : ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      List<PharmacyModel> allPharmacies = List.empty(growable: true);
      List result = toArabic(bodyBytes: response.bodyBytes);
      for (int i = 0; i < result.length; i++) {
        allPharmacies.add(PharmacyModel.formJson(result[i]));
      }
      return allPharmacies;
    } else {
      throw ServerErrorException();
    }
  }
}
