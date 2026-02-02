part of 'all_employees_bloc.dart';

@immutable
abstract class AllEmployeesState {}

class AllEmployeesInitial extends AllEmployeesState {}

class LoadingEmployeeState extends AllEmployeesState {}

class LoadedEmployeesState extends AllEmployeesState {
  final List<(int id ,String name)> emp;

  LoadedEmployeesState({required this.emp});
}

class ErrorEmployeesState extends AllEmployeesState {
  final String error;

  ErrorEmployeesState({required this.error});
}

class DeleteSuccessState extends AllEmployeesState {}