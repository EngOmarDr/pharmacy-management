import 'dart:convert';
import 'dart:io';

import 'package:dashboard/core/constant.dart';
import 'package:dashboard/core/error/exceptions.dart';
import 'package:http/http.dart';

import '../models/shift_model.dart';

abstract interface class ShiftRemoteSource {
  Future<List<(int id, String name)>> allShift(String accessToken);

  Future<ShiftModel> shiftDetail(int id, String accessToken);

  Future<void> createShift(ShiftModel shift, String accessToken);

  Future<void> deleteShift(int id, String accessToken);

  Future<void> updateShift(int id, ShiftModel shift, String accessToken);
}

class ShiftRemoteSourceImpl implements ShiftRemoteSource {
  @override
  Future<List<(int, String)>> allShift(String accessToken) async {
    final response = await get(
      Uri.parse('http://${domain()}/api/shift/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response status : ${response.statusCode} allShift');
    if (response.statusCode == 200) {
      List<(int,String)> result2 = [];
      List<dynamic> result = toArabic(bodyBytes: response.bodyBytes);
      for(int i =0;i<result.length;i++){
        result2.add((result[i]['id'],result[i]['name']));
      }
      return result2;
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> createShift(ShiftModel shift, String accessToken) async {
    final response = await post(
      Uri.parse('http://${domain()}/api/shift/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'},
      body: json.encode(shift.toJson()) ,
    );
    print('response status : ${response.statusCode} createShift');
    if (response.statusCode == 201) {
      return;
    } else if(response.statusCode == 400) {
      throw DetailsException(detail: myDecode(bodyBytes: response.bodyBytes,data: 'errors'));
    }else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> deleteShift(int id, String accessToken) async {
    final response = await delete(
      Uri.parse('http://${domain()}/api/shift/$id/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response status : ${response.statusCode} from deleteShift');
    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 403) {
      throw DetailsException(detail: myDecode(bodyBytes: response.bodyBytes,data: 'error'));
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<ShiftModel> shiftDetail(int id, String accessToken) async {
    final response = await get(
      Uri.parse('http://${domain()}/api/shift/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response status : ${response.statusCode} from shiftDetail');
    if (response.statusCode == 200) {
      Map json = toArabic(bodyBytes: response.bodyBytes);
      final result = ShiftModel.fromJson(json);
      return result;
    }else if(response.statusCode == 400) {
      throw DetailsException(detail: myDecode(bodyBytes: response.bodyBytes,data: 'errors'));
    }else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> updateShift(int id, ShiftModel shift, String accessToken) async {
    final response = await put(
      Uri.parse('http://${domain()}/api/shift/$id/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(shift.toJson()),
    );
    print('response status : ${response.statusCode} from updateShift');
    if (response.statusCode == 200) {
      return ;
    } else if(response.statusCode == 404){
      throw DetailsException(detail: myDecode(bodyBytes: response.bodyBytes,data: 'detail'));
    } else {
      throw ServerErrorException();
    }
  }
}
