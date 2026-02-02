import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

import '../../data/models/employee_model.dart';

class CreateEmployeeUseCase {
  final EmployeeRepositories repository;

  CreateEmployeeUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required int pharmacyId, required EmployeeModel employee}) {
    return repository.createEmployee(
        pharmacyId, employee);
  }
}
