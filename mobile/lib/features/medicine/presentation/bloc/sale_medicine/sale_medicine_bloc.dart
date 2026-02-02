import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/model/medicine_list.dart';

part 'sale_medicine_event.dart';

part 'sale_medicine_state.dart';

class SaleMedicineBloc extends Bloc<SaleMedicineEvent, SaleMedicineState> {
  final price = TextEditingController();
  final quantity = TextEditingController();
  final name = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<({String name, int qty, int price})> listMed =
      List.empty(growable: true);

  List<MedicineList> list = List.empty(growable: true);

  SaleMedicineBloc() : super(SaleMedicineInitialSate()) {
    on<SaleMedicineEvent>((event, emit) async {
      if (event is InitialEvent) {
        emit(LoadingDataState());
        // await Network.allMedicines().then((res) {
        //   list = res;
        // });
        emit(LoadedDataState());
      } else if (event is AddMedicineForSale) {
        if (!formKey.currentState!.validate()) {
          return;
        }
        listMed.add((
          name: name.text,
          qty: int.parse(quantity.text),
          price: int.parse(price.text),
        ));
        price.clear();
        quantity.clear();
        name.clear();
        emit(ChangeMedicinesNumberState());
      } else if (event is InsertBarcodeScannerEvent) {
        if (Platform.isAndroid || Platform.isIOS) {
          ScanResult res = await BarcodeScanner.scan();
          event.copyWith(text: res.rawContent);
          emit(ScanBarcodeState());
        } else {
          AwesomeDialog(
            context: event.context,
            width: Platform.isWindows
                ? MediaQuery.of(event.context).size.width * 0.6
                : null,
            dialogType: DialogType.warning,
            title: 'warning',
            desc: 'you can use barcode scanner in mobile only',
            btnOkOnPress: () {},
          ).show();
        }
      } else if (event is DeleteMedicineEvent) {
        // price.removeAt(event.index);
        // quantity.removeAt(event.index);
        // id.removeAt(event.index);
        // print(price.length);
        // print(id.length);
        emit(ChangeMedicinesNumberState());
      } else if (event is SendDataEvent) {
        if (!formKey.currentState!.validate()) {
          return;
        }
        emit(StartSendDataState());
        // List<Items> items = List.generate(
        // price.length,
        // (index) => Items(
        //     medicine: id[index],
        //     quantity: int.parse(quantity[index].text),
        //     price: int.parse(price[index].text)));
        // await Network.saleMedicine(items).then((res) {
        //   emit(EndSendDataState());
        //   res.fold((l) {
        //     AwesomeDialog(
        //       context: event.context,
        //       width: isWindows()
        //           ? MediaQuery.of(event.context).size.width * 0.6
        //           : null,
        //       dialogType: DialogType.success,
        //       title: 'success',
        //       desc: 'added successfully',
        //       btnOkOnPress: () {},
        //     ).show();
        //     clearData();
        //     emit(ClearDataState());
        //   }, (message) {
        //     AwesomeDialog(
        //       context: event.context,
        //       dialogType: DialogType.error,
        //       width: event.context.size!.width * 0.6,
        //       title: 'error',
        //       desc: message,
        //       btnOkOnPress: () {},
        //     ).show();
        //   });
        // });
      } else if (event is SelectMedicineEvent) {
        // price[event.index].text = '${event.medicine.price}';
        // id[event.index] = event.medicine.id;
        // print(id);
        emit(ChangeMedicinesNumberState());
      }
    });
  }
}
