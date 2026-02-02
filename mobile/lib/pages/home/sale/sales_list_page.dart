import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/pages/home/sale/sales_retrive_page.dart';
import 'package:searchfield/searchfield.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  State<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  List<(int, String)> pharmacies = [];

  Future<void> allPharm() async {
    final response = await get(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    );

    print('response status : ${response.statusCode}');

    if (response.statusCode == 200) {
      pharmacies = [];
      List temp = json.decode(response.body);
      for (var element in temp) {
        pharmacies.add((element['id'], element['name']));
      }
      setState(() {});
    }
  }

  List<Dispose> disposes = [];
  String value = '';
  Future<List<Dispose>> disposeList(String pharmacyId) async {
    final response = await get(
      Uri.http(domain(), '/api/pharmacy/$pharmacyId/sale/'),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    );

    print('response status : ${response.statusCode}');

    if (response.statusCode == 200) {
      disposes = [];
      List temp = json.decode(response.body)['data'];
      for (var element in temp) {
        disposes.add(Dispose(
            id: element['id'],
            user: element['user'],
            time: element['time'],
            value: element['value']));
      }
      value = json.decode(response.body)['value'].toString();
      // setState(() {});
      return disposes;
    }
    return disposes;
  }

  @override
  void initState() {
    if (widget.loginModel.type == 'M') {
      allPharm().then((value) => disposeList(
          '${pharmacyId ?? widget.loginModel.pharmacyId ?? pharmacies[0].$1}'));
    }
    super.initState();
  }

  int? pharmacyId;
  // Future<List<Dispose>> getDisposes = disposeList('${pharmacyId ?? widget.loginModel.pharmacyId ?? 1}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'sales list',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              if (widget.loginModel.type == 'M' && pharmacies.isNotEmpty)
                SearchField<(int, String)>(
                  hint: 'pharmacy',
                  onSuggestionTap: (p0) async {
                    pharmacyId = p0.item?.$1;
                    await disposeList('${p0.item?.$1 ?? 1}');
                    setState(() {});
                  },
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
              FutureBuilder<List<Dispose>>(
                future: disposeList(
                    '${pharmacyId ?? widget.loginModel.pharmacyId ?? 1}'),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Dispose>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageTransition(
                                    SalesRetrivePage(
                                        loginModel: widget.loginModel,
                                        access: widget.loginModel.tokens.access,
                                        disposeId: snapshot.data![i].id,
                                        pharmId: pharmacyId ??
                                            widget.loginModel.pharmacyId ??
                                            pharmacies[0].$1),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.green.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('User: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text((snapshot.data![i].user
                                              .toString())),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('Time: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text((snapshot.data![i].time
                                              .toString())),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('Value: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text((snapshot.data![i].value
                                              .toString())),
                                        ],
                                      ),
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
                                                      '/api/pharmacy/${pharmacyId ?? widget.loginModel.pharmacyId ?? pharmacies[0].$1}/sale/${snapshot.data![i].id}/'),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer ${widget.loginModel.tokens.access}'
                                                  },
                                                );

                                                print(
                                                    'response status : ${response.body} ${response.statusCode} ${pharmacyId ?? widget.loginModel.pharmacyId ?? pharmacies[0].$1}');

                                                if (response.statusCode ==
                                                    204) {
                                                  setState(() {
                                                    disposes.removeAt(i);
                                                  });
                                                }
                                              },
                                            ).show();
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Text(
                          'The sum of the values is : ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
            ],
          ),
        ));
  }
}

class Dispose {
  final int id;
  final String user;
  final String time;
  final int? value;

  Dispose(
      {required this.id,
      required this.user,
      required this.time,
      required this.value});
}
