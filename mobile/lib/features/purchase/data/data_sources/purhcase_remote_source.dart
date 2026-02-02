import 'dart:io';

import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/features/purchase/domain/entities/purchase.dart';


abstract class PurchaseRemoteSource {
  Future<void> addPurchase(
      List<Purchase> purchase, int pharmacyID, String accessToken);

  Future<void> updatePurchase(List<Purchase> purchase, int purchaseID,
      int pharmacyID, String accessToken);

  Future<void> deletePurchase(List<Purchase> purchase, int purchaseID,
      int pharmacyID, String accessToken);

  // Future<Medicine> detailsPurchase(
  //     int purchaseID, int pharmacyID, String accessToken);
  //
  // Future<List<Medicine>> listPurchase(int pharmacyID, String accessToken);
}

class PurchaseRemoteImpl implements PurchaseRemoteSource {
  @override
  Future<void> deletePurchase(List<Purchase> purchase, int purchaseID,
      int pharmacyID, String accessToken) async {
    final response = await delete(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/purchase/$purchaseID/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }

  @override
  Future<void> updatePurchase(List<Purchase> purchase, int purchaseID,
      int pharmacyID, String accessToken) async {
    final response = await put(
        Uri.http(domain(), '/api/pharmacy/$pharmacyID/purchase/$purchaseID/'),
        headers: {
          // HttpHeaders.acceptLanguageHeader: 'ar-ar',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: {
          'items': purchase,
        });

    print('response status : ${response.statusCode}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw DetailsException(
          myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
    }
  }

  @override
  Future<void> addPurchase(
      List<Purchase> purchase, int pharmacyID, String accessToken) async {
    final response = await post(
      Uri.http(domain(), '/api/pharmacy/$pharmacyID/purchase/'),
      headers: {
        // HttpHeaders.acceptLanguageHeader: 'ar-ar',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: {
        'items': purchase,
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

  // @override
  // Future detailsPurchase(
  //     int purchaseID, int pharmacyID, String accessToken) async {
  //   final response = await get(
  //     Uri.http(domain(), '/api/pharmacy/$pharmacyID/purchase/$purchaseID'),
  //     headers: {
  //       // HttpHeaders.acceptLanguageHeader: 'ar-ar',
  //       HttpHeaders.authorizationHeader: 'Bearer $accessToken'
  //     },
  //   );
  //
  //   print('response status : ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     throw DetailsException(
  //         myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
  //   }
  // }

  // @override
  // Future<List> listPurchase(int pharmacyID, String accessToken) async {
  //   final response = await get(
  //     Uri.http(domain(), '/api/pharmacy/$pharmacyID/purchase/'),
  //     headers: {
  //       // HttpHeaders.acceptLanguageHeader: 'ar-ar',
  //       HttpHeaders.authorizationHeader: 'Bearer $accessToken'
  //     },
  //   );
  //
  //   print('response status : ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     return [];
  //   } else {
  //     throw DetailsException(
  //         myDecode(bodyBytes: response.bodyBytes, data: 'errors'));
  //   }
  // }
}
