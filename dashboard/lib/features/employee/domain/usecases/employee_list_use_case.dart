import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

class EmployeeListUseCase {
  final EmployeeRepositories repository;

  EmployeeListUseCase({required this.repository});

  Future<Either<Failure, List<(int id,String name)>>> call({required int pharmacyId}) {
    return repository.employeeList(pharmacyId: pharmacyId);
  }
}
