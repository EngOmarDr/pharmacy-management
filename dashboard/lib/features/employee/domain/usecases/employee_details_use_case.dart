import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/data/models/employee_model.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

class EmployeeDetailsUseCase {
  final EmployeeRepositories repository;

  EmployeeDetailsUseCase({required this.repository});

  Future<Either<Failure, EmployeeModel>> call({required int pharmacyId, required int employeeId}) {
    return repository.employeeDetails(pharmacyId, employeeId);
  }
}
