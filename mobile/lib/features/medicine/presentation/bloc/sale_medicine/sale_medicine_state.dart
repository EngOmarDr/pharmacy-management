part of 'sale_medicine_bloc.dart';

@immutable
abstract class SaleMedicineState {}

class SaleMedicineInitialSate extends SaleMedicineState {}

class ChangeMedicinesNumberState extends SaleMedicineState {}

class ScanBarcodeState extends SaleMedicineState {}

class StartSendDataState extends SaleMedicineState {}

class EndSendDataState extends SaleMedicineState {}

class ClearDataState extends SaleMedicineState {}

class LoadingDataState extends SaleMedicineState {}

class LoadedDataState extends SaleMedicineState {}