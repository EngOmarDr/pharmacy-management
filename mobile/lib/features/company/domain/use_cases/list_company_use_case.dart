import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../entities/company.dart';
import '../repositories/company_repositories.dart';

class ListCompanyUseCase {
  final CompanyRepositories repository;

  ListCompanyUseCase(this.repository);

  Future<Either<Failure, List<Company>>> call() =>
      repository.listCompanies();
}
