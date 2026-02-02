import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;

class PurchaseAddPage extends StatefulWidget {
  const PurchaseAddPage({super.key, required this.loginModel});

  final LoginModel loginModel;
  @override
  State<PurchaseAddPage> createState() => _PurchaseAddPageState();
}

class _PurchaseAddPageState extends State<PurchaseAddPage> {
  String get access => widget.loginModel.tokens.access;
  String get type => widget.loginModel.type;
  int? get pharmId => widget.loginModel.pharmacyId;

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

  List<(int, String)> pharmacies = [];
  getPharmacies() async {
    await http.get(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {'Authorization': 'Bearer $access'},
    ).then(
      (response) {
        print('response status : ${response.statusCode}');

        if (response.statusCode == 200) {
          pharmacies = [];
          List temp = json.decode(response.body);
          for (var element in temp) {
            pharmacies.add((element['id'], element['name']));
          }
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getMedicines();
    if (type == 'M') {
      getPharmacies();
    }
    super.initState();
  }

  int? pharmacyId;

  int? tempMed;
  int itemsNumber = 1;

  List<int> med = [-1];
  List<TextEditingController> price = [TextEditingController()];
  List<TextEditingController> quantity = [TextEditingController()];
  List<TextEditingController> date = [TextEditingController()];

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (widget.loginModel.type == 'M' && pharmacies.isNotEmpty)
              SearchField<(int, String)>(
                hint: 'pharmacy',
                onSuggestionTap: (p0) async {
                  pharmacyId = p0.item!.$1;
                  setState(() {});
                },
                initialValue: SearchFieldListItem(
                  pharmacies[0].$2,
                  item: pharmacies[0],
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(pharmacies[0].$2),
                  ),
                ),
                itemHeight: 50,
                suggestions: pharmacies
                    .map(
                      (e) => SearchFieldListItem<(int, String)>(
                        e.$2,
                        item: e,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(e.$2),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemsNumber,
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
                              hint: 'medicine',
                              validator: nullValidate,
                              onSuggestionTap: (p0) async {
                                tempMed = p0.item!.$1;
                                med.removeAt(index);
                                med.insert(index, p0.item!.$1);

                                setState(() {});
                              },
                              itemHeight: 50,
                              suggestions: medicines
                                  .map(
                                    (e) =>
                                        SearchFieldListItem<(int, String)>(e.$2,
                                            item: e,
                                            child: ListTile(
                                              title: Text(e.$2),
                                            )),
                                  )
                                  .toList(),
                            ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: nullValidate,
                            controller: quantity[index],
                            decoration:
                                const InputDecoration(label: Text('quantity')),
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
                          TextFormField(
                            controller: date[index],
                            decoration: InputDecoration(
                              hintText: 'Expiry Date',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  date[index].clear();

                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            onTap: () async {
                              var from = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 5)));
                              if (from != null) {
                                date[index].text =
                                    DateFormat('yyyy-MM-dd', 'en_us')
                                        .format(from);
                                itemsNumber++;
                                price.add(TextEditingController());
                                quantity.add(TextEditingController());
                                med.add(-1);
                                date.add(TextEditingController());
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  itemsNumber--;
                                  price.removeAt(index);
                                  quantity.removeAt(index);
                                  med.removeAt(index);
                                  date.removeAt(index);
                                });
                              },
                              child: const Text('remove')),
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
                  List finalList = [];
                  for (var i = 0; i < date.length; i++) {
                    finalList.add({
                      'medicine': med[i],
                      'quantity': quantity[i].text.toInt(),
                      'price': price[i].text.toInt(),
                      'expiry_date': date[i].text
                    });
                  }
                  print(finalList);
                  await http
                      .post(
                          Uri.http(domain(),
                              '/api/pharmacy/${pharmacyId ?? pharmId ?? pharmacies[0].$1}/purchase/'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $access'
                          },
                          body: json.encode({'items': finalList}))
                      .then(
                    (response) async {
                      print('response status : ${response.statusCode}');

                      if (response.statusCode == 201) {
                        await myAwesomeDlg(
                                context: context,
                                message: 'add successfully',
                                title: '',
                                type: DialogType.success)
                            .then((value) {
                          med = [-1];
                          price = [TextEditingController()];
                          quantity = [TextEditingController()];
                          date = [TextEditingController()];
                          itemsNumber = 1;
                          setState(() {});
                        });
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
    );
  }
}

class DisposeAdd {
  final int medicine;
  final int quantity;
  final int price;
  final String expiryDate;

  DisposeAdd(
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
