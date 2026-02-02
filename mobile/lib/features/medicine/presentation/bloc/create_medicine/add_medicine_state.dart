part of 'add_medicine_bloc.dart';

@immutable
abstract class AddMedicineState {}

class AddMedicineInitial extends AddMedicineState {}

class ChangeControllerState extends AddMedicineState {}

class StartSendDataState extends AddMedicineState {}

class FinishSendDateState extends AddMedicineState {}

class ChangeDropdownValueState extends AddMedicineState {}

class ChangeCheckBoxValueState extends AddMedicineState {
  final bool needPrescription;

  ChangeCheckBoxValueState(this.needPrescription);
}

class StartLoadingCompanyiesState extends AddMedicineState {}

class FinishLoadingCompanyiesState extends AddMedicineState {}
