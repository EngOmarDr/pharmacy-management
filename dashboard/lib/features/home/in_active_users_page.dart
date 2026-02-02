import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../core/constant.dart';

class InActiveUsersPage extends StatefulWidget {
  const InActiveUsersPage(
      {Key? key, required this.pharmacyId, required this.token})
      : super(key: key);

  final int? pharmacyId;
  final String token;

  @override
  State<InActiveUsersPage> createState() => _InActiveUsersPageState();
}

class _InActiveUsersPageState extends State<InActiveUsersPage> {
  Future<List<(int id, String name)>> getData(String? value) async {
    final response = await get(
        Uri.http(domain(), '/api/pharmacy/${value?? widget.pharmacyId}/unactive_employee/'),
        headers: {'Authorization': 'Bearer ${widget.token}'});

    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      final List<(int id, String name)> res = [];
      final List temp = jsonDecode(response.body);
      for (var element in temp) {
        res.add((element['id'], element['name']));
      }
      return res;
    } else {
      throw Exception();
    }
  }

  Future<bool> activeUser(int userID) async {
    final response = await patch(
        Uri.http(domain(),
            '/api/pharmacy/${widget.pharmacyId}/unactive_employee/$userID/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
        body: {'': 'nothing'});

    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      // getData();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text('in active users'),
      ),
      body: Column(
        children: [
          if (widget.pharmacyId == null)
            Center(
              child: SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'pharmacy id'
                  ),
                  controller:
                      TextEditingController(text: '${widget.pharmacyId ?? 1}'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      return;
                    }
                    print(value);
                    await getData(value);
                  },
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<(int id, String name)>>(
              future: getData('${widget.pharmacyId ?? '1'}'),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    print(data?.isEmpty);
                    if (data == null || data.isEmpty) {
                      return const Center(
                        child: Text('empty'),
                      );
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data[index].$2),
                          trailing: IconButton(
                              onPressed: () {
                                activeUser(data[index].$1).then((value) {
                                  if (value) {
                                    data.removeAt(index);
                                    getData('1');
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline)),
                        );
                      },
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
