import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';

part 'equals_state.dart';

class EqualsCubit extends Cubit<EqualsState> {
  EqualsCubit() : super(LoadingMedicinesState());

  List<(int, String)> medicines = [];

  List<(int, String)> medicinesEqual = [];

  List<(int, String)> selectedMedicines = [];

  Future<void> getListMedicines(String accessToken) async {
    // selectedMedicines
    final response = await get(
      Uri.http(domain(), '/api/medicine/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print('response status : ${response.statusCode}');

    if (response.statusCode == 200) {
      medicines = [];
      List temp = json.decode(response.body);
      for (var element in temp) {
        medicines.add((element['id'], element['brand_name']));
      }
      print(medicines);
      emit(FinishLoadingMedicinesState());
    }
  }

  addOrDeleteMedicine((int, String) medicine, {bool isAdd = true}) {
    if (isAdd) {
      // selectedMedicines.
      selectedMedicines.add(medicine);
      selectedMedicines = selectedMedicines.toSet().toList();
    } else {
      selectedMedicines.remove(medicine);
    }
    emit(AddOrDeleteItemState());
  }

  addEquals(String accessToken) async {
    emit(LoadingCreatingEqualsState());
    List<int> temp = [];
    for (var element in selectedMedicines) {
      temp.add(element.$1);
    }
    int m = temp.removeAt(0);
    print(m.toString() + temp.toList().toString());
    final response = await post(Uri.http(domain(), '/api/medicine/$m/equals/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'ids': temp,
        }));
    print(selectedMedicines);
    print('response status : ${response.body}');

    if (response.statusCode == 201) {
      selectedMedicines = [];
    }
    emit(FinishCreatingEqualsState());
  }

  getEquals(String access, int idMed) async {
    emit(LoadingCreatingEqualsState());
    final response = await get(
      Uri.http(domain(), '/api/medicine/$idMed/equals/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      },
    );
    print(selectedMedicines);
    print('response status : ${response.body}');

    if (response.statusCode == 200) {
      medicinesEqual = [];
      List temp = jsonDecode(response.body);
      for (var i in temp) {
        medicinesEqual.add((i['id'], i['brand_name']));
      }
      print(medicinesEqual);
    }
    emit(FinishCreatingEqualsState());
  }

  deleteEquals(String access, int idMed) async {
    emit(LoadingCreatingEqualsState());
    final response = await delete(
      Uri.http(domain(), '/api/medicine/$idMed/equals/remove/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      },
    );
    print(selectedMedicines);
    print('response status : ${response.body}');

    if (response.statusCode == 204) {
      await getEquals(access, idMed);
    }
    emit(FinishCreatingEqualsState());
  }
}
