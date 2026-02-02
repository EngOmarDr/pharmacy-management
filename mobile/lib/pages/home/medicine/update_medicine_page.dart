import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/medicine_type.dart';
import 'package:pharmacy/core/utils/my_text_field_widget.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/medicine/domain/entities/medicine.dart';
import 'package:searchfield/searchfield.dart';

class UpdateMedicinePage extends StatefulWidget {
  const UpdateMedicinePage(
      {super.key, required this.loginModel, required this.medicine});

  final LoginModel loginModel;
  final Medicine medicine;

  @override
  State<UpdateMedicinePage> createState() => _UpdateMedicinePageState();
}

class _UpdateMedicinePageState extends State<UpdateMedicinePage> {
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

  var name = TextEditingController();
  var priceSale = TextEditingController();
  var pricePurchase = TextEditingController();
  var quantity = TextEditingController();
  var barcode = TextEditingController();
  int companyId = 0;
  bool needPrescription = false;
  bool isActive = true;

  final formKey = GlobalKey<FormState>();

  bool isLoading = true;
  List<(int, String)> companies = [];
  (int, String)? initCom = (0, '');
  Future<void> getComp() async {
    await get(
      Uri.http(domain(), '/api/company/'),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          companies = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            companies.add((element['id'], element['name']));
          }
          for (var e in companies) {
            if (e.$1 == widget.medicine.company) {
              initCom = e;
            }
          }

          print(initCom);
          // initCom = listCom!.$1;
        }
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    getComp();
    medicineType = widget.medicine.type;

    name = TextEditingController(text: widget.medicine.brandName);
    priceSale =
        TextEditingController(text: widget.medicine.salePrice.toString());
    pricePurchase =
        TextEditingController(text: widget.medicine.purchasePrice.toString());
    quantity =
        TextEditingController(text: widget.medicine.minQuantity.toString());
    barcode = TextEditingController(text: widget.medicine.barcode);
    companyId = widget.medicine.company;
    needPrescription = widget.medicine.needPrescription;
    super.initState();
  }

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('update medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                MyTextField(
                  controller: name,
                  lText: 'Name',
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: priceSale,
                        keyType: TextInputType.number,
                        validator: (p0) {
                          switch (p0) {
                            case null:
                              return "can't be empty";
                            case '':
                              return "can't be empty";
                          }
                          return int.parse(p0) == 0 ? "can't be $p0" : null;
                        },
                        format: [FilteringTextInputFormatter.digitsOnly],
                        lText: 'Price sale',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        controller: pricePurchase,
                        keyType: TextInputType.number,
                        validator: (p0) {
                          switch (p0) {
                            case null:
                              return "can't be empty";
                            case '':
                              return "can't be empty";
                          }
                          return int.parse(p0) == 0 ? "can't be $p0" : null;
                        },
                        format: [FilteringTextInputFormatter.digitsOnly],
                        lText: 'Price purchase',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        controller: quantity,
                        keyType: TextInputType.number,
                        validator: (p0) {
                          switch (p0) {
                            case null:
                              return "can't be empty";
                            case '':
                              return "can't be empty";
                          }
                          return int.parse(p0) == 0 ? "can't be $p0" : null;
                        },
                        format: [FilteringTextInputFormatter.digitsOnly],
                        lText: 'min Quantity',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                MyTextField(
                  keyType: TextInputType.number,
                  controller: barcode,
                  maxL: 13,
                  validator: (text) {
                    nullValidate;
                    if (text!.length != 13) {
                      return 'you have to be 13 number';
                    }
                    return null;
                  },
                  format: [FilteringTextInputFormatter.digitsOnly],
                  lText: 'Barcode',
                  preIcon: IconButton(
                    onPressed: () async {
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
                          return;
                        });
                      } else {
                        AwesomeDialog(
                          context: context,
                          width: Platform.isWindows
                              ? MediaQuery.of(context).size.width * 0.6
                              : null,
                          dialogType: DialogType.warning,
                          title: 'warning',
                          desc: 'you can use barcode scanner in mobile only',
                          btnOkOnPress: () {},
                        ).show();
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.qr_code, color: Colors.black),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SearchField<(int id, String name)>(
                        hint: 'company',
                        initialValue:
                            SearchFieldListItem(initCom!.$2, item: initCom),
                        onSuggestionTap: (p0) {
                          setState(() {
                            companyId = p0.item!.$1;
                          });
                        },
                        itemHeight: 50,
                        scrollbarAlwaysVisible: true,
                        maxSuggestionsInViewPort: 4,
                        suggestions: companies
                            .map(
                              (e) => SearchFieldListItem<(int id, String name)>(
                                e.$2,
                                item: e,
                                child: ListTile(
                                  title: Text(e.$2),
                                  leading: const Image(
                                    image: AssetImage(
                                        'assets/images/companies.png'),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                const SizedBox(height: 15),
                Container(
                  color: Colors.green[100],
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w900),
                        dropdownColor: Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: 200,
                        items: listItems,
                        value: medicineType,
                        onChanged: (newValue) {
                          setState(() {
                            medicineType = newValue;
                          });
                        }),
                  ),
                ),
                const SizedBox(height: 15),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Need Prescription'),
                    value: needPrescription,
                    onChanged: (bool? value) {
                      setState(() {
                        needPrescription = !needPrescription;
                      });
                    }),
                const SizedBox(height: 15),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('is Active'),
                    value: isActive,
                    onChanged: (bool? value) {
                      setState(() {
                        isActive = !isActive;
                      });
                    }),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40)),
                  onPressed: () async {
                    setState(() {
                      isSending = true;
                    });
                    if (!formKey.currentState!.validate() || companyId == 0) {
                      return;
                    }
                    print('=======================');
                    Map body = {
                      'brand_name': name.text,
                      'barcode': barcode.text,
                      'company': '$companyId',
                      'sale_price': priceSale.text,
                      'purchase_price': pricePurchase.text,
                      'need_prescription': needPrescription ? '1' : '0',
                      'min_quanity': quantity.text,
                      'type': medicineType.toString(),
                      'is_active': isActive ? '1' : '0'
                    };

                    print(jsonEncode(body));
                    await put(
                            Uri.http(domain(),
                                '/api/medicine/${widget.medicine.id}/'),
                            headers: {
                              // 'Content-Type': 'application/json',
                              'Authorization':
                                  'Bearer ${widget.loginModel.tokens.access}'
                            },
                            body: body)
                        .then((response) {
                      print('response status : ${response.body}');

                      if (response.statusCode == 200) {
                        AwesomeDialog(
                          context: context,
                          width: isWindows()
                              ? MediaQuery.of(context).size.width * 0.6
                              : null,
                          dialogType: DialogType.success,
                          title: 'success',
                          desc: 'updated successfully',
                          btnOkOnPress: () {},
                        ).show().then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        AwesomeDialog(
                          context: context,
                          width: isWindows()
                              ? MediaQuery.of(context).size.width * 0.6
                              : null,
                          dialogType: DialogType.error,
                          title: 'error',
                          desc: myDecode(
                              bodyBytes: response.bodyBytes, data: 'errors'),
                          btnOkOnPress: () {},
                        ).show();
                      }
                    });
                    setState(() {
                      isSending = false;
                    });
                  },
                  child: isSending
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
