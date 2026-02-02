import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/pharmacy/domain/use_cases/update_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/features/pharmacy/domain/use_cases/create_use_case.dart';
import 'package:flutter/material.dart';

import '../../../data/models/pharmacy_model.dart';

part 'create_update_pharmacy_state.dart';

class CreateOrUpdatePharmacyCubit extends Cubit<CreateOrUpdatePharmacyState> {
  CreateOrUpdatePharmacyCubit(
      {required this.createUseCase, required this.updateUseCase})
      : super(CreateOrUpdatePharmacyInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final regionP = TextEditingController();
  final nameP = TextEditingController();
  final cityP = TextEditingController();
  final streetP = TextEditingController();
  final phoneNumberP = TextEditingController();
  final CreatePharmacyUseCase createUseCase;
  final UpdatePharmacyUseCase updateUseCase;

  sendData(int? id) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(LoadingState());
    final Either<Failure, Unit> result;
    if (id == null) {
      PharmacyModel phar = PharmacyModel.withoutId(
          phoneNumber: int.parse(phoneNumberP.text),
          street: streetP.text,
          city: cityP.text,
          name: nameP.text,
          region: regionP.text);
      result = await createUseCase(pharmacy: phar);
      result.fold((failure) {
        if(failure.runtimeType == DetailsFailure) {
          failure as DetailsFailure;
          print(failure.error + failure.runtimeType.toString());
          emit(ErrorCreateOrUpdatePharmacyState(error: failure.error));
      }}, (type) {
        cleanField();
        emit(CreateOrUpdatePharmacySuccessState());
      });
    } else {
      PharmacyModel phar = PharmacyModel(
          id: id,
          phoneNumber: int.parse(phoneNumberP.text),
          street: streetP.text,
          city: cityP.text,
          name: nameP.text,
          region: regionP.text);
      result = await updateUseCase(pharmacy: phar);
      result.fold(
        (failure) {
          if(failure.runtimeType == DetailsFailure) {
            failure as DetailsFailure;
            print(failure.error + failure.runtimeType.toString());
            emit(ErrorCreateOrUpdatePharmacyState(error: failure.error));
          }
          emit(ErrorCreateOrUpdatePharmacyState());
        },
        (type) => emit(CreateOrUpdatePharmacySuccessState()),
      );
    }
  }



  void cleanField() {
    formKey.currentState!.reset();
    regionP.clear();
    nameP.clear();
    cityP.clear();
    streetP.clear();
    phoneNumberP.clear();
  }
}
