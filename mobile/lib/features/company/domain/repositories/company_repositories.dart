import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../../data/models/company_model.dart';
import '../entities/company.dart';

abstract class CompanyRepositories {
  Future<Either<Failure, Company>> createCompany(CompanyModel company);

  Future<Either<Failure, Company>> updateCompany(
      CompanyModel companyModel, int companyID);

  Future<Either<Failure, Unit>> deleteCompany(int companyID);

  Future<Either<Failure, Company>> companyDetail(int companyID);

  Future<Either<Failure, List<Company>>> listCompanies();
}
