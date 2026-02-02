import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/utils/my_text_field_widget.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/company/presentation/bloc/company_bloc.dart';
import 'package:pharmacy/features/company/presentation/pages/create_company.dart';
import 'package:pharmacy/features/medicine/presentation/bloc/create_medicine/add_medicine_bloc.dart';
import '../../../../../injection_container.dart';
import 'package:searchfield/searchfield.dart';

class AddMedicinePage extends StatelessWidget {
  const AddMedicinePage({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    print('========== Build Add Medicine ==========');
    final bloc = BlocProvider.of<AddMedicineBloc>(context)
      ..add(GetCompaniesEvent(loginModel.tokens.access));
    return Scaffold(
      appBar: AppBar(
        title: const Text('create medicine'),
      ),
      body: BlocBuilder<AddMedicineBloc, AddMedicineState>(
          builder: (context, state) {
        if (state is StartLoadingCompanyiesState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Form(
                key: bloc.formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MyTextField(
                      controller: bloc.name,
                      lText: 'Name',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: bloc.priceSale,
                            keyType: TextInputType.number,
                            validator: (p0) {
                              switch (p0) {
                                case null:
                                  return "can't be empty";
                                case '':
                                  return "can't be empty";
                              }
                              return int.parse(p0) == 0 ? "can't be $p0" : null;
                            },
                            format: [FilteringTextInputFormatter.digitsOnly],
                            lText: 'Price sale',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyTextField(
                            controller: bloc.pricePurchase,
                            keyType: TextInputType.number,
                            validator: (p0) {
                              switch (p0) {
                                case null:
                                  return "can't be empty";
                                case '':
                                  return "can't be empty";
                              }
                              return int.parse(p0) == 0 ? "can't be $p0" : null;
                            },
                            format: [FilteringTextInputFormatter.digitsOnly],
                            lText: 'Price purchase',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyTextField(
                            controller: bloc.quantity,
                            keyType: TextInputType.number,
                            validator: (p0) {
                              switch (p0) {
                                case null:
                                  return "can't be empty";
                                case '':
                                  return "can't be empty";
                              }
                              return int.parse(p0) == 0 ? "can't be $p0" : null;
                            },
                            format: [FilteringTextInputFormatter.digitsOnly],
                            lText: 'min Quantity',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      keyType: TextInputType.number,
                      controller: bloc.barcode,
                      maxL: 13,
                      validator: bloc.barcodeValidator,
                      format: [FilteringTextInputFormatter.digitsOnly],
                      lText: 'Barcode',
                      preIcon: IconButton(
                        onPressed: () {
                          bloc.add(InsertBarcodeScannerEvent(context));
                        },
                        icon: const Icon(Icons.qr_code, color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SearchField<(int id, String name)>(
                      hint: 'company',
                      onSuggestionTap: (p0) {
                        bloc.add(ChangeCompanySelectedEvent(p0.item!.$1));
                      },
                      itemHeight: 50,
                      scrollbarAlwaysVisible: true,
                      maxSuggestionsInViewPort: 4,
                      suggestions: bloc.companies
                          .map(
                            (e) => SearchFieldListItem<(int id, String name)>(
                              e.$2,
                              item: e,
                              child: ListTile(
                                title: Text(e.$2),
                                leading: const Image(
                                    image: AssetImage(
                                        'assets/images/companies.png')),
                                // trailing: const Image(
                                //   image: AssetImage('assets/images/companies.png')),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: TextButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => BlocProvider(
                                create: (context) => sl<CompanyBloc>(),
                                child: const CreateCompany(),
                              ),
                            ).then((value) {
                              bloc.add(
                                  GetCompaniesEvent(loginModel.tokens.access));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('add successfully'),
                                behavior: SnackBarBehavior.floating,
                                elevation: 10,
                                backgroundColor: Colors.green,
                              ));
                            });
                          },
                          child: const Text('create company')),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<AddMedicineBloc, AddMedicineState>(
                      builder: (context, state) {
                        return Container(
                          color: Colors.green[100],
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w900),
                                dropdownColor: Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                                menuMaxHeight: 200,
                                items: bloc.listItems,
                                value: bloc.medicineType,
                                onChanged: (newValue) {
                                  bloc.add(ChangeDropdownValueEvent(newValue));
                                }),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<AddMedicineBloc, AddMedicineState>(
                      builder: (context, state) {
                        print('---------- Build Check Box ----------');
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Need Prescription'),
                          value: bloc.needPrescription,
                          onChanged: (bool? value) =>
                              bloc.add(ChangeCheckBoxEvent(value)),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40)),
                      onPressed: () {
                        bloc.add(
                            SendDataEvent(context, loginModel.tokens.access));
                      },
                      child: BlocBuilder<AddMedicineBloc, AddMedicineState>(
                        buildWhen: (previous, current) {
                          return current is StartSendDataState ||
                              current is FinishSendDateState;
                        },
                        builder: (context, state) {
                          print(
                              '---------- Build Child Elevated Button ----------');
                          return state is StartSendDataState
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('submit');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
