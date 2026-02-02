import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/medicine_type.dart';

part 'add_medicine_event.dart';
part 'add_medicine_state.dart';

class AddMedicineBloc extends Bloc<AddMedicineEvent, AddMedicineState> {
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
  String medicineType = MedicineType.values[0].value;

  final name = TextEditingController();
  final priceSale = TextEditingController();
  final pricePurchase = TextEditingController();
  final quantity = TextEditingController();
  final barcode = TextEditingController();
  int companyId = 0;

  bool needPrescription = false;

  final formKey = GlobalKey<FormState>();

  List<(int id, String name)> companies = [];

  AddMedicineBloc() : super(AddMedicineInitial()) {
    on<AddMedicineEvent>((event, emit) async {
      if (event is ChangeCompanySelectedEvent) {
        companyId = event.compId;
      }
      if (event is GetCompaniesEvent) {
        print('-=--------------------------------------=======');
        emit(StartLoadingCompanyiesState());
        await get(
          Uri.http(domain(), '/api/company/'),
          headers: {'Authorization': 'Bearer ${event.accessToken}'},
        ).then(
          (response) {
            print('response status : ${response.statusCode}');

            if (response.statusCode == 200) {
              companies = [];
              List temp = json.decode(response.body);
              for (var element in temp) {
                companies.add((element['id'], element['name']));
              }
              emit(FinishLoadingCompanyiesState());
            }
          },
        );
      } else if (event is InsertExpiryDateEvent) {
        DateTime expiry = DateTime.now();
        showDialog(
          context: event.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Year'),
              content: SizedBox(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 100),
                  initialDate: DateTime.now(),
                  selectedDate: expiry,
                  onChanged: (DateTime dateTime) {
                    expiry = dateTime;
                    // expiryDate.text = expiry.year.toString();
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
        emit(ChangeControllerState());
      } else if (event is InsertBarcodeScannerEvent) {
        if (Platform.isAndroid || Platform.isIOS) {
          await BarcodeScanner.scan().then((res) {
            if (res.format.name == BarcodeFormat.ean13.name) {
              barcode.text = res.rawContent;
            } else {
              AwesomeDialog(
                context: event.context,
                width: Platform.isWindows
                    ? MediaQuery.of(event.context).size.width * 0.6
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
      } else if (event is SendDataEvent) {
        if (!formKey.currentState!.validate() || companyId == 0) {
          return;
        }
        print('=======================');
        emit(StartSendDataState());
        Map body = {
          'brand_name': name.text,
          'barcode': barcode.text,
          'company': '$companyId',
          'sale_price': priceSale.text,
          'purchase_price': pricePurchase.text,
          'need_prescription': needPrescription ? '1' : '0',
          'min_quanity': quantity.text,
          'type': medicineType.toString()
        };

        print('${jsonEncode(body)}$body');
        await post(Uri.http(domain(), '/api/medicine/'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${event.access}'
                },
                body: jsonEncode(body))
            .then((response) {
          print('response status : ${response.statusCode}');

          if (response.statusCode == 201) {
            AwesomeDialog(
              context: event.context,
              width: isWindows()
                  ? MediaQuery.of(event.context).size.width * 0.6
                  : null,
              dialogType: DialogType.success,
              title: 'success',
              desc: 'added successfully',
              btnOkOnPress: () {},
            ).show();
            emit(FinishSendDateState());
          } else {
            AwesomeDialog(
              context: event.context,
              width: isWindows()
                  ? MediaQuery.of(event.context).size.width * 0.6
                  : null,
              dialogType: DialogType.error,
              title: 'error',
              desc: myDecode(bodyBytes: response.bodyBytes, data: 'errors'),
              btnOkOnPress: () {},
            ).show();
            emit(FinishSendDateState());
          }
        });
      } else if (event is ChangeDropdownValueEvent) {
        medicineType = event.newValue;
        emit(ChangeDropdownValueState());
      } else if (event is ChangeCheckBoxEvent) {
        needPrescription = !needPrescription;
        emit(ChangeCheckBoxValueState(needPrescription));
      }
    });
  }

  String? barcodeValidator(String? text) {
    nullValidate;
    if (text!.length != 13) {
      return 'you have to be 13 number';
    }
    return null;
  }
}


// await Network.addMedicine(medicine).then((res) {
//   emit(FinishSendDateState());
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
//     clearDate();
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