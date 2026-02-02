import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/data/models/employee_model.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepositories repository;

  UpdateEmployeeUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(
      {required int pharmacyId, required EmployeeModel employee, required int employeeId}) {
    return repository.updateEmployee(pharmacyId, employeeId , employee);
  }
}
