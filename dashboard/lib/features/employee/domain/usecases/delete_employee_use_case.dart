import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepositories repository;

  DeleteEmployeeUseCase({required this.repository});

  Future<Either<Failure, Object>> call({required int pharmacyId, required int employeeId}) {
    return repository.deleteEmployee(pharmacyId, employeeId);
  }
}
