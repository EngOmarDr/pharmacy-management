part of 'inventory_cubit.dart';

@immutable
abstract class InventoryState {}

class LoadingInfoState extends InventoryState {}

class ChangeDropdownValueState extends InventoryState {}

class FinishLoadingState extends InventoryState {}

class LoadingResultState extends InventoryState {}

class FinishLoadingResultState extends InventoryState {}

class ChangeControllerState extends InventoryState {}
