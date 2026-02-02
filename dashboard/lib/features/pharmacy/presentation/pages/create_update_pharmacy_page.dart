import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/core/responsive.dart';
import 'package:dashboard/core/utils/my_text_field_widget.dart';
import 'package:dashboard/features/pharmacy/domain/entities/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/create_update_pharmacy/create_update_pharmacy_cubit.dart';

class CreatePharmacyPage extends StatelessWidget {
  const CreatePharmacyPage({Key? key, this.pharmacy}) : super(key: key);

  final Pharmacy? pharmacy;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CreateOrUpdatePharmacyCubit>(context);
    cubit.phoneNumberP.text = pharmacy?.phoneNumber.toString() ?? '';
    cubit.nameP.text = pharmacy?.name.toString() ?? '';
    cubit.regionP.text = pharmacy?.region.toString() ?? '';
    cubit.cityP.text = pharmacy?.city.toString() ?? '';
    cubit.streetP.text = pharmacy?.street.toString() ?? '';

    return BlocListener<CreateOrUpdatePharmacyCubit,
        CreateOrUpdatePharmacyState>(
      listener: (context, state) async {
        if (state is ErrorCreateOrUpdatePharmacyState) {
          AwesomeDialog(
            context: context,
            width: !Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 2
                : null,
            title: 'error',
            body: Text(state.error ?? 'server error'),
            dialogType: DialogType.error,
            animType: AnimType.scale,
            btnOkOnPress: () {},
          ).show();
        } else if (state is CreateOrUpdatePharmacySuccessState) {
          AwesomeDialog(
            context: context,
            width: !Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 2
                : null,
            title: 'success',
            body: Text(pharmacy == null
                ? 'added successfully'
                : 'updated successfully'),
            dialogType: DialogType.success,
            animType: AnimType.scale,
            btnOkOnPress: () {
              Navigator.pop(context,true);
            },
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              pharmacy == null ? 'create new pharmacy' : 'edit your pharmacy'),
        ),
        body: Stack(
          children: [
            const Opacity(
              opacity: 0.7,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/logo2.png'),
                ),
              ),
            ),
            Form(
              key: cubit.formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                children: [
                  MyTextField(
                    controller: cubit.nameP,
                    lText: 'name',
                  ).gap(),
                  MyTextField(
                    controller: cubit.phoneNumberP,
                    keyType: TextInputType.number,
                    maxL: 10,
                    validator: (p0) {
                      if(p0==null){
                        return "can't be empty";
                      }else if(p0.trim().isEmpty){
                        return "can't be empty";
                      }else if(p0.length!=10){
                        return "must be 10 letter";
                      }
                      return null;
                    },
                    format: [FilteringTextInputFormatter.digitsOnly],
                    lText: 'Number',
                  ).gap(),
                  MyTextField(
                    controller: cubit.cityP,
                    lText: 'City',
                  ).gap(),
                  MyTextField(
                    controller: cubit.regionP,
                    lText: 'Region',
                  ).gap(),
                  MyTextField(
                    controller: cubit.streetP,
                    lText: 'street',
                  ).gap(),
                  FilledButton(onPressed: () {
                    cubit.sendData(pharmacy?.id);
                  }, child: BlocBuilder<CreateOrUpdatePharmacyCubit,
                      CreateOrUpdatePharmacyState>(
                    builder: (context, state) {
                      return state is LoadingState
                          ? const SizedBox(
                              height: 30, child: CircularProgressIndicator())
                          : Text(pharmacy == null ? 'submit' : 'update');
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
