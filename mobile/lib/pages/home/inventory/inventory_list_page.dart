import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/my_text_field_widget.dart';
import 'package:searchfield/searchfield.dart';

import '../../../features/auth/data/models/login_model.dart';
import 'cubit/inventory_cubit.dart';

class InventoryListPage extends StatelessWidget {
  const InventoryListPage({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<InventoryCubit>(context)
      ..getPharMedCom(loginModel.tokens.access);
    return Scaffold(
      appBar: AppBar(
        title: const Text('inventory list'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
          if (state is LoadingInfoState) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              if (loginModel.type == 'M' && cubit.pharmacies.isNotEmpty)
                SearchField<(int, String)>(
                  hint: 'pharmacy',
                  controller: cubit.phar,
                  itemHeight: 50,
                  suggestions: cubit.pharmacies
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
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.green[100],
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w900),
                      dropdownColor: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                      menuMaxHeight: 200,
                      items: cubit.listItems,
                      value: cubit.medicineType,
                      hint: const Text('medicine type'),
                      padding: const EdgeInsets.only(left: 10),
                      onChanged: (newValue) {
                        cubit.changeDropDown(newValue);
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (cubit.companies.isNotEmpty)
                SearchField<(int, String)>(
                  hint: 'company',
                  controller: cubit.com,
                  itemHeight: 50,
                  suggestions: cubit.companies
                      .map(
                        (e) => SearchFieldListItem<(int, String)>(
                          e.$2,
                          item: e,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                                const Image(
                                    image: AssetImage(
                                        'assets/images/companies.png')),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e.$2),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(
                height: 15,
              ),
              if (cubit.medicines.isNotEmpty)
                SearchField<(int, String)>(
                  hint: 'medicine',
                  controller: cubit.med,
                  itemHeight: 50,
                  suggestions: cubit.medicines
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
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.green[100],
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w900),
                      dropdownColor: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                      menuMaxHeight: 200,
                      items: cubit.listItemsOrder,
                      value: cubit.orderType,
                      hint: const Text('order by'),
                      padding: const EdgeInsets.only(left: 10),
                      onChanged: (newValue) {
                        cubit.changeDropDown1(newValue);
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextField(
                keyType: TextInputType.number,
                controller: cubit.barcode,
                maxL: 13,
                validator: (text) {
                  nullValidate;
                  if (text!.length != 13) {
                    return 'you have to be 13 number';
                  }
                  return null;
                },
                format: [FilteringTextInputFormatter.digitsOnly],
                lText: 'Barcode',
                preIcon: IconButton(
                  onPressed: () {
                    cubit.scanBarcode(context);
                  },
                  icon: const Icon(Icons.qr_code, color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                  onPressed: () {
                    cubit.inventoryList(loginModel.tokens.access,
                        '${(cubit.phar.text.isEmpty) ? loginModel.pharmacyId ?? 1 : cubit.phar.text}');
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('search')),
              const SizedBox(height: 15),
              if (state is LoadingResultState)
                const Center(child: CircularProgressIndicator())
              else if (cubit.listInv.isEmpty || cubit.listInv == [])
                const Text(
                  'no medicine found',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.listInv.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    return Card(
                      child: SizedBox(
                        child: ListTile(
                          title: Text(cubit.listInv[index].brandName),
                          trailing:
                              Text(cubit.listInv[index].quantity.toString()),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        }),
      ),
    );
  }
}
