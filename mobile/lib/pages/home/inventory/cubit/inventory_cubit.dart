import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/medicine_type.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(LoadingInfoState());

  static List<(String name, String value)> oreder = [
    ('name', 'brand_name'),
    ('name Desc', '-brand_name'),
    ('quantity', 'quantity'),
    ('quantity Desc', '-quantity'),
  ];
  String? orderType;
  List<DropdownMenuItem<String>> listItemsOrder =
      List<DropdownMenuItem<String>>.generate(
    oreder.length,
    (index) => DropdownMenuItem<String>(
      value: oreder[index].$2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          oreder[index].$1,
        ),
      ),
    ),
  );

  List<DropdownMenuItem> listItems = List<DropdownMenuItem>.generate(
    MedicineType.values.length,
    (index) => DropdownMenuItem(
      value: MedicineType.values[index].value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          MedicineType.values[index].nameEn,
        ),
      ),
    ),
  );
  String? medicineType;

  final com = TextEditingController();
  final phar = TextEditingController();
  final med = TextEditingController();
  final barcode = TextEditingController();

  List<(int, String)> medicines = [];
  List<(int, String)> companies = [];
  List<(int, String)> pharmacies = [];

  void getPharMedCom(String accessToken) {
    http.get(
      Uri.http(domain(), '/api/medicine/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          medicines = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            medicines.add((element['id'], element['brand_name']));
          }
          emit(FinishLoadingState());
        }
      },
    );

    http.get(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          pharmacies = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            pharmacies.add((element['id'], element['name']));
          }
          emit(FinishLoadingState());
        }
      },
    );

    http.get(
      Uri.http(domain(), '/api/company/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          companies = [];
          print(response.bodyBytes);
          List temp = json.decode(response.body);
          for (var element in temp) {
            companies.add((element['id'], element['name']));
          }
          emit(FinishLoadingState());
        }
      },
    );

    // emit(FinishLoadingMedicinesState());
  }

  void changeDropDown(String newValue) {
    medicineType = newValue;
    emit(ChangeDropdownValueState());
  }

  void changeDropDown1(String? newValue) {
    orderType = newValue;
    emit(ChangeDropdownValueState());
  }

  List<Inventory> listInv = [];
  Future<void> inventoryList(String access, String pharId) async {
    print('${phar.text}hkhjk');
    emit(LoadingResultState());
    await http.get(
      Uri.parse(
          'http://${domain()}/api/pharmacy/$pharId/inventory/?type=${medicineType ?? ''}&barcode=${barcode.text.isEmpty ? '' : barcode.text}&brand_name=${med.text.isEmpty ? ' ' : med.text}&company=${com.text.isEmpty ? ' ' : com.text}&ordering=${orderType ?? ''}'),
      headers: {'Authorization': 'Bearer $access'},
    ).then(
      (response) {
        print('response status : ${response.body}');

        if (response.statusCode == 200) {
          listInv = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            listInv.add(Inventory(element['id'], element['brand_name'],
                element['company'], element['quantity']));
          }
          emit(FinishLoadingResultState());
        }
      },
    );
  }

  scanBarcode(BuildContext context) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await BarcodeScanner.scan().then((res) {
        if (res.format.name == BarcodeFormat.ean13.name) {
          barcode.text = res.rawContent;
        } else {
          AwesomeDialog(
            context: context,
            width: Platform.isWindows
                ? MediaQuery.of(context).size.width * 0.6
                : null,
            dialogType: DialogType.warning,
            title: 'warning',
            desc: 'error in scan try again',
            btnOkOnPress: () {},
          ).show();
        }
        emit(ChangeControllerState());
        return;
      });
    } else {
      AwesomeDialog(
        context: context,
        width:
            Platform.isWindows ? MediaQuery.of(context).size.width * 0.6 : null,
        dialogType: DialogType.warning,
        title: 'warning',
        desc: 'you can use barcode scanner in mobile only',
        btnOkOnPress: () {},
      ).show();
    }
  }
}

class Inventory {
  final int id;
  final String brandName;
  final int company;
  final int quantity;

  Inventory(this.id, this.brandName, this.company, this.quantity);
}
