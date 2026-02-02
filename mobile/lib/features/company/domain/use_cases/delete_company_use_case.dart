import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../repositories/company_repositories.dart';

class DeleteCompanyUseCase {
  final CompanyRepositories repository;

  DeleteCompanyUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int companyID}) =>
      repository.deleteCompany(companyID);
}
