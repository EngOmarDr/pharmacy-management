import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/exceptions.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/core/network_info.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
import 'package:dashboard/features/employee/data/datasources/employee_remote_source.dart';
import 'package:dashboard/features/employee/data/models/employee_model.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';

class EmployeeRepoImpl implements EmployeeRepositories {
  final EmployeeRemoteSource remoteSource;
  final AuthLocalSource authLocalSource;
  final NetworkInfo networkInfo;

  EmployeeRepoImpl(
      {required this.authLocalSource,
      required this.remoteSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> createEmployee(
      int pharmacyId, EmployeeModel employee) async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await authLocalSource.getStoreData();
        await remoteSource.createEmployee(
            pharmacyId: pharmacyId,
            accessToken: loginModel!.tokens.access,
            employeeModel: employee);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on DetailsException catch(e){
        return Left(DetailsFailure(error: e.detail));
      }on Exception {
        return Left(UnKnownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEmployee(
      int pharmacyId, int employeeId) async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await authLocalSource.getStoreData();
        await remoteSource.deleteEmployee(
            pharmacyId, employeeId, loginModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on Exception {
        return Left(UnKnownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> employeeDetails(
      int pharmacyId, int employeeId) async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await authLocalSource.getStoreData();
        final result = await remoteSource.employeeDetails(
            pharmacyId, employeeId, loginModel!.tokens.access);
        return Right(result);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on Exception {
        return Left(UnKnownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<(int id, String name)>>> employeeList(
      {required int pharmacyId}) async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await authLocalSource.getStoreData();
        final listE = await remoteSource.employeeList(
            pharmacyId, loginModel!.tokens.access);
        return Right(listE);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on Exception {
        return Left(UnKnownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmployee(
      int pharmacyId, int employeeId, EmployeeModel employee) async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await authLocalSource.getStoreData();
        await remoteSource.updateEmployee(
            pharmacyId, employeeId, employee, loginModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on DetailsException catch (e) {
        return Left(DetailsFailure(error: e.detail));
      } on Exception {
        return Left(UnKnownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
