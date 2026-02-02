part of 'all_employees_bloc.dart';

@immutable
abstract class AllEmployeesEvent {}

class GetEmployeesEvent extends AllEmployeesEvent{
  final int pharmacyId;

  GetEmployeesEvent({required this.pharmacyId});
}

class CreateOrUpdateEmployeeEvent extends AllEmployeesEvent{
  final BuildContext context;
  final int? empId;
  final int pharID;

  CreateOrUpdateEmployeeEvent({required this.pharID, required this.context, this.empId});
}

class DeleteEmployeeEvent extends AllEmployeesEvent{
  final int pharID;
  final int empID;
  final List<(int ,String)> empList;
  final int index;

  DeleteEmployeeEvent({required this.index, required this.empList, required this.pharID, required this.empID});
}

class DetailsEmployeeEvent extends AllEmployeesEvent{}