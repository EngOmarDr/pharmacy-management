import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/core/utils/my_text_field_widget.dart';
import 'package:pharmacy/features/company/data/models/company_model.dart';
import 'package:pharmacy/features/company/domain/entities/company.dart';
import 'package:pharmacy/features/company/presentation/bloc/company_bloc.dart';

class CreateCompany extends StatelessWidget {
  const CreateCompany({Key? key, this.company}) : super(key: key);

  final Company? company;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CompanyBloc>(context);

    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final phone = TextEditingController();
    name.text = company != null ? company!.name : '';
    phone.text = company != null ? company!.phone : '';

    return BlocListener<CompanyBloc, CompanyState>(
      listener: (context, state) {
        if (state is SuccessRequestState) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Create Company',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: name,
                lText: 'name',
                validator: nullValidate,
              ),
              const SizedBox(height: 10),
              MyTextField(
                  controller: phone,
                  lText: 'phone number',
                  validator: nullValidate,
                  keyType: TextInputType.number),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<CompanyBloc, CompanyState>(
                  builder: (context, state) {
                    print(state);
                    return state is LoadingState
                        ? const CircularProgressIndicator()
                        : FilledButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              Navigator.pop(context);
                              final comMod = CompanyModel(
                                  name: name.text, phone: phone.text);

                              bloc.deletedCom = Company(
                                  id: company?.id ?? -1,
                                  name: name.text,
                                  phone: phone.text);
                              company == null
                                  ? bloc.add(CreateCompanyEvent(comMod))
                                  : bloc.add(UpdateCompanyEvent());
                            },
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
