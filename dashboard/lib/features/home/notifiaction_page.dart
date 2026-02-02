import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../core/constant.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.pharmacyId, required this.token}) : super(key: key);

  final int pharmacyId;
  final String token;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {

    super.initState();
  }

  Future<List> getData() async {
    final response = await get(
      Uri.http(domain(), '/api/pharmacy/${widget.pharmacyId}/notification/'),
      headers: {
        'Authorization': 'Bearer ${widget.token}'
      }
    );

    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) ;
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('list notification'),
      ),
      body: FutureBuilder(
        future: getData(),
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
              final data = snapshot.data ;
              print(data?.isEmpty);
              if(data == null || data.isEmpty ) {
                return const Center(child: Text('no notification'),);
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].toString()),
                );
              },);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
