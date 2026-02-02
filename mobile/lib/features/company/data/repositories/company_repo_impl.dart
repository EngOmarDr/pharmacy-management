import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/core/network_info.dart';
import 'package:pharmacy/features/company/domain/entities/company.dart';

import '../../../auth/data/dataSources/auth_local_source.dart';
import '../../domain/repositories/company_repositories.dart';
import '../data_sources/company_remote_source.dart';
import '../models/company_model.dart';

class CompanyRepoImpl implements CompanyRepositories {
  final CompanyRemoteSource companyRemoteSource;

  final AuthLocalSource authLocalSource;
  final NetworkInfo networkInfo;

  const CompanyRepoImpl(
      {required this.authLocalSource,
      required this.networkInfo,
      required this.companyRemoteSource});

  @override
  Future<Either<Failure, Company>> createCompany(CompanyModel company) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final companyRes = await companyRemoteSource.createCompany(
            company, authModel!.tokens.access);
        return Right(companyRes);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } on DetailsException catch (e) {
        return Left(DetailsFailure(e.detail));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCompany(int companyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await companyRemoteSource.deleteCompany(
            companyId, authModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } on DetailsException catch (e) {
        return Left(DetailsFailure(e.detail));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Company>> companyDetail(int companyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final comRes = await companyRemoteSource.companyDetail(
            companyId, authModel!.tokens.access);
        return Right(comRes);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Company>> updateCompany(
      CompanyModel company, int companyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final comRes = await companyRemoteSource.updateCompany(
            company, companyId, authModel!.tokens.access);
        return Right(comRes);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } on DetailsException catch (e) {
        return Left(DetailsFailure(e.detail));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Company>>> listCompanies() async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final result =
            await companyRemoteSource.listCompanies(authModel!.tokens.access);
        return Right(result);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
