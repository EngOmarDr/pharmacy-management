import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/medicine/domain/entities/medicine.dart';
import 'package:pharmacy/pages/home/medicine/update_medicine_page.dart';

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  State<MedicineListPage> createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<Medicine> medicines = [];

  Future<List<Medicine>> allPharm() async {
    final response = await get(
      Uri.http(domain(), '/api/medicine/'),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    );

    print('response status : ${response.statusCode}');

    if (response.statusCode == 200) {
      medicines = [];
      List temp = json.decode(response.body);
      for (var element in temp) {
        medicines.add(Medicine(
            id: element['id'],
            brandName: element['brand_name'],
            barcode: element['barcode'],
            company: element['company'],
            salePrice: element['sale_price'],
            purchasePrice: element['purchase_price'],
            needPrescription: element['need_prescription'],
            minQuantity: element['min_quanity'],
            type: element['type']));
      }
      // setState(() {});
    }
    return medicines;
  }

  String value = '';

  @override
  void initState() {
    allPharm();
    super.initState();
  }

  int? pharmacyId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'medicine list',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Medicine>>(
            future: allPharm(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Medicine>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return Card(
                      color: snapshot.data![i].needPrescription
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text('company: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text((snapshot.data![i].company.toString())),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text((snapshot.data![i].brandName)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('barcode: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text((snapshot.data![i].barcode.toString())),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('barcode: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text((snapshot.data![i].barcode.toString())),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('sale price: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(('${snapshot.data![i].salePrice}\t')),
                                const Text('purchase price: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '${snapshot.data![i].purchasePrice}',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('min quantity: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('${snapshot.data![i].minQuantity}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('type: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(snapshot.data![i].type),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      AwesomeDialog(
                                        context: context,
                                        body: const Text('are you sure?'),
                                        title: 'warning',
                                        dialogType: DialogType.warning,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          final response = await delete(
                                            Uri.http(domain(),
                                                '/api/medicine/${snapshot.data![i].id}/'),
                                            headers: {
                                              'Authorization':
                                                  'Bearer ${widget.loginModel.tokens.access}'
                                            },
                                          );

                                          print(
                                              'response status : ${response.body} ${response.statusCode}');

                                          if (response.statusCode == 204) {
                                            setState(() {
                                              medicines.removeAt(i);
                                            });
                                          }
                                        },
                                      ).show();
                                    },
                                    icon: const Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(UpdateMedicinePage(
                                            loginModel: widget.loginModel,
                                            medicine: snapshot.data![i],
                                          )));
                                    },
                                    icon: const Icon(Icons.edit)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
