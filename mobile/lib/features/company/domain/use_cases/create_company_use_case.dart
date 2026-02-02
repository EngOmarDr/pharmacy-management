import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/company/data/models/company_model.dart';

import '../entities/company.dart';
import '../repositories/company_repositories.dart';

class CreateCompanyUseCase {
  final CompanyRepositories repository;

  CreateCompanyUseCase(this.repository);

  Future<Either<Failure, Company>> call({required CompanyModel companyModel}) =>
      repository.createCompany(companyModel);
}
