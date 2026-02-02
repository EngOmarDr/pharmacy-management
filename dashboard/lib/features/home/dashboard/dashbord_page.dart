import 'dart:convert';

import 'package:dashboard/core/constant.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:searchfield/searchfield.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.loginModel}) : super(key: key);

  final LoginModel loginModel;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final phar = TextEditingController();

  List<(int, String)> pharmacies = [];

  Map<String, double>? values;
  String total = '0';
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    getDash();
    http.get(
      Uri.http(domain(), '/api/pharmacy/'),
      headers: {'Authorization': 'Bearer ${widget.loginModel.tokens.access}'},
    ).then((response) {
      print('response status : ${response.statusCode}');

      if (response.statusCode == 200) {
        pharmacies = [];
        List temp = json.decode(response.body);
        for (var element in temp) {
          pharmacies.add((element['id'], element['name']));
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (widget.loginModel.type == 'M' && pharmacies.isNotEmpty)
              SearchField<(int, String)>(
                hint: 'pharmacy'.tr(),
                controller: phar,
                itemHeight: 50,
                suggestions: pharmacies
                    .map(
                      (e) => SearchFieldListItem<(int, String)>(
                        e.$1.toString(),
                        item: e,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(e.$2.toString()),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 15),
            TextFormField(
              controller: fromController,
              decoration: InputDecoration(
                hintText: 'from Date'.tr(),
                suffixIcon : IconButton(
                  onPressed: () {
                    fromController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              onTap: () async {
                var from = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().copyWith(year: 2022),
                    firstDate: DateTime.now().copyWith(year: 2022),
                    lastDate: DateTime.now());
                if (from != null) {
                  fromController.text =
                      DateFormat('yyyy-MM-dd', 'en_us').format(from);
                  print(fromController.text);
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: toController,
              decoration: InputDecoration(
                hintText: 'until Date'.tr(),
                suffixIcon: IconButton(
                  onPressed: () {
                    toController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              onTap: () async {
                var to = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().copyWith(year: 2022),
                    firstDate: DateTime.now().copyWith(year: 2022),
                    lastDate: DateTime.now());
                if (to != null) {
                  toController.text =
                      DateFormat('yyyy-MM-dd', 'en_us').format(to);
                  print(toController.text);
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () async {
                await getDash();
              },
              child: const Text('search').tr(),
            ),
            const SizedBox(height: 15),
            Text(
              'total profit is'.tr() + ' ' + '${total.replaceAllMapped(reg, mathFunc)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            if (values != null)
              PieChart(
                dataMap: values!,
                legendOptions:
                    const LegendOptions(legendPosition: LegendPosition.top),
                chartValuesOptions: const ChartValuesOptions(
                  decimalPlaces: 1,
                ),
              )
          ],
        ),
      ),
    );
  }

  getDash() async {
    final response = await http.get(Uri.parse(
        'http://${domain()}/api/pharmacy/${(phar.text.isEmpty) ? widget.loginModel.pharmacyId ?? 1 : phar.text}/transaction/?since=${fromController.text}&until=${toController.text}'));
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);
      values = {
        'purchases': (temp['purchases'] as int).toDouble(),
        'sales': (temp['sales'] as int).toDouble(),
        'returns': (temp['returns'] as int).toDouble(),
        'disposals': (temp['disposals'] as int).toDouble(),
      };
      total = temp['total_profit'].toString();
      setState(() {});
    }
  }
//  change
}
