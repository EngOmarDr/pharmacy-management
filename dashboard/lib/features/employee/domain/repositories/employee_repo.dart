import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/data/models/employee_model.dart';

abstract class EmployeeRepositories {
  Future<Either<Failure, List<(int id,String name)>>> employeeList({required int pharmacyId});

  Future<Either<Failure, EmployeeModel>> employeeDetails(
      int pharmacyId, int employeeId);

  Future<Either<Failure, Unit>> createEmployee(
      int pharmacyId,EmployeeModel employee);

  Future<Either<Failure, Unit>> deleteEmployee(
      int pharmacyId, int employeeId);

  Future<Either<Failure, Unit>> updateEmployee(
      int pharmacyId, int employeeId, EmployeeModel employee);
}