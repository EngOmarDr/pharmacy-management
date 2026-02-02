part of 'add_medicine_bloc.dart';

@immutable
abstract class AddMedicineEvent {}

class InsertExpiryDateEvent extends AddMedicineEvent {
  final BuildContext context;

  InsertExpiryDateEvent(this.context);
}

class InsertBarcodeScannerEvent extends AddMedicineEvent {
  final BuildContext context;

  InsertBarcodeScannerEvent(this.context);
}

class SendDataEvent extends AddMedicineEvent {
  final BuildContext context;
  final String access;

  SendDataEvent(this.context, this.access);
}

class ChangeDropdownValueEvent extends AddMedicineEvent {
  final String newValue;

  ChangeDropdownValueEvent(this.newValue);
}

class ChangeCheckBoxEvent extends AddMedicineEvent {
  final bool? needPrescription;

  ChangeCheckBoxEvent(this.needPrescription);
}

class GetCompaniesEvent extends AddMedicineEvent {
  final String accessToken;

  GetCompaniesEvent(this.accessToken);
}

class ChangeCompanySelectedEvent extends AddMedicineEvent {
  final int compId;

  ChangeCompanySelectedEvent(this.compId);
}
