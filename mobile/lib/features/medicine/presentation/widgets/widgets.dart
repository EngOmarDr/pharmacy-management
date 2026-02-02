import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/my_text_field_widget.dart';
import 'package:pharmacy/model/medicine_list.dart';
import 'package:searchfield/searchfield.dart';

import '../bloc/sale_medicine/sale_medicine_bloc.dart';

class BuildAutoComplete extends StatelessWidget {
  const BuildAutoComplete({Key? key, required this.bloc}) : super(key: key);

  final SaleMedicineBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<MedicineList>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          validator: nullValidate,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  bloc.add(InsertBarcodeScannerEvent(
                      context, textEditingController.text));
                },
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              suffixIcon: IconButton(
                onPressed: () => bloc.name.clear(),
                icon: const Icon(Icons.clear),
              )),
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      displayStringForOption: (option) {
        return bloc.state is ClearDataState ? '' : option.brandName;
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
          color: Colors.green[100],
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: MediaQuery.of(context).size.width - 70),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (_, int index) {
                return options.toList()[index].isExpired
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: ListTile(
                          tileColor: options.toList()[index].quantity == 0
                              ? Colors.red.shade200
                              : Colors.white60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.green),
                          ),
                          onTap: options.toList()[index].quantity == 0
                              ? null
                              : () {
                                  onSelected(options.toList()[index]);
                                },
                          title: Text(options.toList()[index].brandName),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
      optionsBuilder: (textEditingValue) async {
        bool isInt = int.tryParse(textEditingValue.text).runtimeType == int
            ? true
            : false;
        if (isInt) {
          return bloc.list.where((element) => element.barcode
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        } else {
          return bloc.list.where((element) => element.brandName
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        }
      },
      onSelected: (option) =>
          option.quantity < 1 ? null : bloc.add(SelectMedicineEvent(option)),
    );
  }
}

class BuildCardMedicine extends StatelessWidget {
  const BuildCardMedicine({Key? key, required this.bloc}) : super(key: key);
  static List<String>company = ['Ahmad','yazan','omar','mohamed'];
  final SaleMedicineBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder(
          curve: Curves.bounceInOut,
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, double value, child) => Transform.scale(
            scale: value,
            child: Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Personal information (OPTIONAL)',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: bloc.price, ////change this
                            validator: nullValidate,
                            validMode: AutovalidateMode.disabled,
                            lText: 'Doctor Name',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MyTextField(
                            validMode: AutovalidateMode.disabled,
                            controller: bloc.quantity,//change this
                            validator: nullValidate,
                            lText: 'Customer Name',
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ), const SizedBox(height: 15),
        TweenAnimationBuilder(
          curve: Curves.bounceInOut,
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, double value, child) => Transform.scale(
            scale: value,
            child: Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Medicine information',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    BuildAutoComplete(bloc: bloc),
                    const SizedBox(height: 15),
                    SearchField<String>(
                      hint: 'medicine name',
                      suggestions: company
                          .map(
                            (e) => SearchFieldListItem<String>(
                          e,
                          item: e,
                          // Use child to show Custom Widgets in the suggestions
                          // defaults to Text widget
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                                  const Image(color: Colors.green,
                                      image: AssetImage('assets/images/medicine.png')),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            keyType: TextInputType.number,
                            controller: bloc.price,
                            validator: nullValidate,
                            validMode: AutovalidateMode.disabled,
                            format: [
                              FilteringTextInputFormatter.allow(RegExp(r'^$|[1-9]'))
                            ],
                            lText: 'Price',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MyTextField(
                            validMode: AutovalidateMode.disabled,
                            controller: bloc.quantity,
                            keyType: TextInputType.number,
                            validator: nullValidate,
                            format: [
                              FilteringTextInputFormatter.allow(RegExp(r'^$|[1-9]'))
                            ],
                            lText: 'Quantity',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: ElevatedButton(
                          onPressed: () {
                            bloc.add(AddMedicineForSale());
                          },
                          child: const Text('add')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
