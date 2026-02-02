import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/pages/home/sale/sales_retrive_page.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;

class SalesUpdatePage extends StatefulWidget {
  const SalesUpdatePage(
      {super.key,
      required this.loginModel,
      required this.disposeId,
      required this.itemsDispose,
      required this.pharmId});

  final LoginModel loginModel;
  final int disposeId;
  final List itemsDispose;
  final int pharmId;
  @override
  State<SalesUpdatePage> createState() => _SalesUpdatePageState();
}

class _SalesUpdatePageState extends State<SalesUpdatePage> {
  String get access => widget.loginModel.tokens.access;

  List<(int, String)> medicines = [];
  getMedicines() async {
    await http.get(
      Uri.http(domain(), '/api/medicine/'),
      headers: {'Authorization': 'Bearer $access'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          medicines = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            medicines.add((element['id'], element['brand_name']));
          }
        }
      },
    );
    setState(() {});
  }

  List<(String batch, int quantity)> batches = [];
  getBatches(int medicineId) async {
    await http.get(
      Uri.http(domain(),
          '/api/pharmacy/${widget.pharmId}/inventory/$medicineId/batches'),
      headers: {'Authorization': 'Bearer $access'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          batches = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            batches.add((element['batch'], element['quantity']));
          }
          // setState(() {});
        }
      },
    );
  }

  int? tempMed;
  int itemsNumber = 1;

  List<int> med = [];
  List<TextEditingController> price = [];
  List<TextEditingController> quantity = [];
  List<String> date = [];
  List finalList = [];

  @override
  void initState() {
    List tmpDis = widget.itemsDispose;
    getMedicines();
    for (var i = 0; i < widget.itemsDispose.length; i++) {
      price.add(TextEditingController(text: '${tmpDis[i]['price']}'));
      quantity.add(TextEditingController(text: '${tmpDis[i]['quantity']}'));
      med.add(tmpDis[i]['medicine']);
      date.add(tmpDis[i]['expiry_date']);
    }
    super.initState();
  }

  final formState = GlobalKey<FormState>();

  String getMedName(int id) {
    for (var element in medicines) {
      if (element.$1 == id) {
        return element.$2;
      }
    }
    return '';
  }

  (int, String) getMedNameId(int id) {
    for (var element in medicines) {
      if (element.$1 == id) {
        return element;
      }
    }
    return (1, '');
  }

  String getExpiryName(int id) {
    for (var element in batches) {
      if (element.$2 == id) {
        return element.$1;
      }
    }
    return '';
  }

  (String, int) getExpiryNameId(String date) {
    for (var element in batches) {
      if (element.$1 == date) {
        return element;
      }
    }
    return ('', 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('update sales'),
      ),
      body: Form(
        key: formState,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.itemsDispose.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            if (medicines.isNotEmpty)
                              SearchField<(int, String)>(
                                hint: getMedName(widget.itemsDispose[index]
                                        ['medicine']
                                    .toInt()),
                                validator: nullValidate,
                                onSuggestionTap: (p0) async {
                                  tempMed = p0.item!.$1;
                                  med.removeAt(index);
                                  med.insert(index, p0.item!.$1);
                                  await getBatches(p0.item!.$1);
                                  setState(() {});
                                },
                                itemHeight: 50,
                                suggestions: medicines
                                    .map(
                                      (e) => SearchFieldListItem<(int, String)>(
                                        e.$2,
                                        item: e,
                                        child: ListTile(
                                          title: Text(e.$2),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            const SizedBox(height: 15),
                            TextFormField(
                              validator: nullValidate,
                              controller: quantity[index],
                              decoration: const InputDecoration(
                                  label: Text('quantity')),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: price[index],
                              validator: nullValidate,
                              decoration:
                                  const InputDecoration(label: Text('price')),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            if (tempMed == null)
                              const Text('you have to shoose medicine')
                            else if (batches.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            else
                              SearchField<(String batch, int quantity)>(
                                hint: 'expiry date',
                                validator: nullValidate,
                                onSuggestionTap: (p0) async {
                                  date.removeAt(index);
                                  date.insert(index, p0.item!.$1);
                                  setState(() {});
                                },
                                itemHeight: 50,
                                suggestions: batches
                                    .map(
                                      (e) => SearchFieldListItem<(String, int)>(
                                          e.$1,
                                          item: e,
                                          child: ListTile(
                                            title: Text(e.$1),
                                            trailing: Text(e.$2.toString()),
                                          )),
                                    )
                                    .toList(),
                              ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              FilledButton(
                  onPressed: () async {
                    if (!formState.currentState!.validate()) {
                      return;
                    }
                    finalList = [];
                    for (var i = 0; i < date.length; i++) {
                      finalList.add({
                        'medicine': med[i],
                        'quantity': quantity[i].text.toInt(),
                        'price': price[i].text.toInt(),
                        'expiry_date': date[i]
                      });
                    }
                    print(finalList);
                    await http
                        .put(
                            Uri.http(domain(),
                                '/api/pharmacy/${widget.pharmId}/sale/${widget.disposeId}/'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $access'
                            },
                            body: json.encode({'items': finalList}))
                        .then(
                      (response) async {
                        print(
                            'response status : ${response.statusCode} ==============');

                        if (response.statusCode == 200) {
                          await myAwesomeDlg(
                            context: context,
                            message: 'updated successfully',
                            title: '',
                            type: DialogType.success,
                          ).then((value) =>
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                  SalesRetrivePage(
                                      loginModel: widget.loginModel,
                                      access: widget.loginModel.tokens.access,
                                      disposeId: widget.disposeId,
                                      pharmId: widget.pharmId),
                                ),
                              ));
                        } else {
                          myAwesomeDlg(
                              context: context,
                              message: jsonDecode(response.body)['errors'],
                              title: 'Error',
                              type: DialogType.error);
                        }
                      },
                    );
                  },
                  child: const Text('submit'))
            ],
          ),
        ),
      ),
    );
  }
}

class DisposeUpdate {
  final int medicine;
  final int quantity;
  final int price;
  final String expiryDate;

  DisposeUpdate(
      {required this.medicine,
      required this.quantity,
      required this.price,
      required this.expiryDate});
}

extension Num on String {
  toInt() {
    return int.parse(this);
  }
}
