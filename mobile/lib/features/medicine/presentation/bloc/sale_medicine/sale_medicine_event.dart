part of 'sale_medicine_bloc.dart';

@immutable
abstract class SaleMedicineEvent {}

class InitialEvent extends SaleMedicineEvent {}

class AddMedicineForSale extends SaleMedicineEvent {}

class InsertBarcodeScannerEvent extends SaleMedicineEvent {
  final BuildContext context;
  final String text;

  InsertBarcodeScannerEvent(this.context,this.text);

  InsertBarcodeScannerEvent copyWith({BuildContext? context,String? text}){
    return InsertBarcodeScannerEvent(context ?? this.context, text ?? this.text);
  }
}

class DeleteMedicineEvent extends SaleMedicineEvent {
  final int index;

  DeleteMedicineEvent(this.index);
}

class SendDataEvent extends SaleMedicineEvent{
  final BuildContext context;

  SendDataEvent(this.context);
}

class SelectMedicineEvent extends SaleMedicineEvent{
  final MedicineList medicine;

  SelectMedicineEvent(this.medicine);
}