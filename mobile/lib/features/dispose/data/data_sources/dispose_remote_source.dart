import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/features/dispose/domain/entities/dispose_retrieve.dart';
import 'package:pharmacy/features/purchase/domain/entities/purchase.dart';

abstract class DisposeRemoteSource {
  Future<void> addDispose(
      List<Purchase> items, int pharmacyID, String accessToken);

  Future<void> updateDispose(
      List<Purchase> items, int disposeID, int pharmacyID, String accessToken);

  Future<void> deleteDispose(
      List<Purchase> items, int disposeID, int pharmacyID, String accessToken);

  Future<DisposeRetrieve> retrieveDispose(
      int disposeID, int pharmacyID, String accessToken);

// Future<List<Medicine>> listDispose(String accessToken);
}

class DisposeRemoteImpl implements DisposeRemoteSource {

  @override
  Future<void> addDispose(
      List<Purchase> items, int pharmacyID, String accessToken) async {
    final response = await post(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/dispose/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: {
        'items': items,
      },
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
  Future<void> deleteDispose(List<Purchase> items, int disposeID,
      int pharmacyID, String accessToken) async {
    final response = await delete(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/dispose/$disposeID/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: {
        'items': items,
      },
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
  Future<DisposeRetrieve> retrieveDispose(
      int disposeID, int pharmacyID, String accessToken) async {
    final response = await delete(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/dispose/$disposeID/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return DisposeRetrieve.fromJson(jsonDecode(toArabic(response.bodyBytes)));
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }

  @override
  Future<void> updateDispose(List<Purchase> items,int disposeID, int pharmacyID, String accessToken) async {
    final response = await put(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/dispose/$disposeID/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: {
        'items': items,
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }
}
