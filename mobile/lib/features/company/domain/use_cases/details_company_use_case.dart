import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../entities/company.dart';
import '../repositories/company_repositories.dart';

class DetailsCompanyUseCase {
  final CompanyRepositories repository;

  DetailsCompanyUseCase(this.repository);

  Future<Either<Failure, Company>> call({required int companyID}) =>
      repository.companyDetail(companyID);
}
