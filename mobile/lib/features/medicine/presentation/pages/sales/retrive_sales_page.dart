import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/features/auth/data/models/login_model.dart';

class RetriveSales extends StatefulWidget {
  const RetriveSales({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  State<RetriveSales> createState() => _RetriveSales();
}

class _RetriveSales extends State<RetriveSales> {
  Future getData() async {
    var url = 'http://10.0.2.2:8000/api/company/1';
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
            'Retrive Sales',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                        color: Colors.green.shade200,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Name: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text((snapshot.data['name']
                                        .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Phone Number: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text((snapshot.data['phone_number']
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
