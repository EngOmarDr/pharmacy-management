import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/error/exceptions.dart';

import '../../domain/entities/medicine.dart';
import '../models/medicine_model.dart';

abstract class MedicineRemoteSource {
  Future<void> createMedicine(MedicineModel medicine, String accessToken);

  Future<void> updateMedicine(MedicineModel medicine, int medicineID,
      String accessToken);

  Future<void> deleteMedicine(int medicineID, String accessToken);

  Future<Medicine> detailsMedicine(int medicineID, String accessToken);

  Future<List<Medicine>> listMedicines(String accessToken);
}

class MedicineRemoteImpl implements MedicineRemoteSource {
  @override
  Future<void> createMedicine(MedicineModel medicine,
      String accessToken) async {
    final response = await
    post(Uri.http(domain(), '/api/medicine/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: medicine.toJson(),
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }

  @override
  Future<void> deleteMedicine(int medicineID, String accessToken) async {
    final response = await delete(
      Uri.http(domain(), '/api/medicine/$medicineID/'),
      headers: {
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
  Future<Medicine> detailsMedicine(int medicineID, String accessToken) async {
    final response = await delete(
      Uri.http(domain(), '/api/medicine/$medicineID/'),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return Medicine.fromJson(json.decode(response.body));
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<List<Medicine>> listMedicines(String accessToken) async {
    final response = await get(
      Uri.http(domain(), '/api/medicine/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print('response status : ${response.statusCode}');
    print(
        'response status : ${response.body} ${json
            .decode(response.body)
            .runtimeType}');
    if (response.statusCode == 200) {
      List temp = json.decode(response.body);
      List<Medicine> allComp = [];
      for (var element in temp) {
        allComp.add(Medicine.fromJson(element));
      }
      return allComp;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> updateMedicine(MedicineModel medicine, int medicineID,
      String accessToken) async {
    final response =
    await put(Uri.http(domain(), '/api/company/$medicineID/'),
        headers: {
          HttpHeaders.acceptLanguageHeader: 'ar-ar',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: medicine.toJson());

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }
}

