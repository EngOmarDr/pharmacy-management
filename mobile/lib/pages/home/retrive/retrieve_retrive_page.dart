import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';

import 'retrieve_update_page.dart';

class RetrieveRetrivePage extends StatefulWidget {
  const RetrieveRetrivePage(
      {super.key,
      required this.disposeId,
      required this.pharmId,
      required this.access,
      required this.loginModel});

  final int disposeId;
  final LoginModel loginModel;
  final int pharmId;
  final String access;
  @override
  State<RetrieveRetrivePage> createState() => _RetrieveRetrivePageState();
}

class _RetrieveRetrivePageState extends State<RetrieveRetrivePage> {
  // List<DisposeRetrive> disposeRetrive = [];

  Future<DisposeRetrive?> disposeRetrive() async {
    final response = await get(
      Uri.http(domain(),
          '/api/pharmacy/${widget.pharmId}/retrive/${widget.disposeId}'),
      headers: {'Authorization': 'Bearer ${widget.access}'},
    );

    print('response status : ${response.statusCode}');

    DisposeRetrive? disposesRetrive;
    if (response.statusCode == 200) {
      Map temp = json.decode(response.body);
      disposesRetrive = DisposeRetrive(
          id: temp['id'],
          user: temp['user'],
          items: temp['items'],
          time: temp['time'],
          value: temp['value']);
    }
    return disposesRetrive;
  }

  @override
  void initState() {
    disposeRetrive();
    super.initState();
  }

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'retrive get',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<DisposeRetrive?>(
          future: disposeRetrive(),
          builder:
              (BuildContext context, AsyncSnapshot<DisposeRetrive?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: [
                  Row(
                    children: [
                      const Text('User: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        snapshot.data!.user,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Time: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text((snapshot.data!.time)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Value: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        snapshot.data!.value.toString().replaceAllMapped(
                              reg,
                              (match) => mathFunc(match),
                            ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (context, i) {
                      return Card(
                        color: Colors.green.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text('medicine: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '${snapshot.data!.items[i]['medicine']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('quantity: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot.data!.items[i]['quantity']
                                      .toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('price: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot.data!.items[i]['price']
                                      .toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('expiry date: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot.data!.items[i]['expiry_date']
                                      .toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            RetrieveUpdatePage(
                                pharmId: widget.pharmId,
                                loginModel: widget.loginModel,
                                disposeId: widget.disposeId,
                                itemsDispose: snapshot.data!.items),
                          ),
                        );
                      },
                      child: const Text('update')),
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
      ),
    );
  }
}

class DisposeRetrive {
  final int id;
  final String user;
  final List items;
  final String time;
  final int value;

  DisposeRetrive(
      {required this.id,
      required this.user,
      required this.items,
      required this.time,
      required this.value});
}
