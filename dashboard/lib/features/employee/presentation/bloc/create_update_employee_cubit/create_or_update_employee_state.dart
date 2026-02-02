part of 'create_or_update_employee_cubit.dart';

@immutable
abstract class CreateOrUpdateEmployeeState {}

class CreateOrUpdateEmployeeInitial extends CreateOrUpdateEmployeeState {}

class ChangeObscurePasswordState extends CreateOrUpdateEmployeeState {}

class LoadingCreateEmployeeState extends CreateOrUpdateEmployeeState {}

class LoadedCreateEmployeeState extends CreateOrUpdateEmployeeState {}

class LoadingShiftState extends CreateOrUpdateEmployeeState {}

class LoadedShiftState extends CreateOrUpdateEmployeeState {
  final List<(int,String)> allShift;

  LoadedShiftState(this.allShift);
}

class ChangeRadioState extends CreateOrUpdateEmployeeState {}

class ChangeActiveState extends CreateOrUpdateEmployeeState {}

class ErrorCreateOrUpdateEmployeeState extends CreateOrUpdateEmployeeState {
  final String error;

  ErrorCreateOrUpdateEmployeeState({required this.error});
}

class GetEmpDetailState extends CreateOrUpdateEmployeeState {}

class FinishEmpDetailState extends CreateOrUpdateEmployeeState {}