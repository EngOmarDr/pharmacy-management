import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/features/auth/data/models/login_model.dart';

class AllRetrives extends StatefulWidget {
  const AllRetrives({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  State<AllRetrives> createState() => _AllRetrivesState();
}

class _AllRetrivesState extends State<AllRetrives> {
  Future getData() async {
    var url = 'http://10.0.2.2:8000/api/pharmacy/1/retrive/';
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    );
    var responsebody = jsonDecode(response.body);
    print(responsebody);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Retrives',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data['data'].length,
                  itemBuilder: (context, i) {
                    return Card(
                        color: Colors.green.shade200,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('User: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text((snapshot.data['data'][i]['user']
                                        .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Time: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text((snapshot.data['data'][i]['time']
                                        .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Value: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text((snapshot.data['data'][i]['value']
                                        .toString())),
                                  ],
                                ),
                              ],
                            )));
                  });
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
