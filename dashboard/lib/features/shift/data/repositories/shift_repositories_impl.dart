import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/exceptions.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/core/network_info.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';
import 'package:dashboard/features/shift/domain/repositories/shift_repositories.dart';

import '../data_sources/shift_remote_source.dart';

class ShiftRepositoriesImpl implements ShiftRepositories {
  final ShiftRemoteSource _remoteSource;
  final AuthLocalSource _authLocalSource;
  final NetworkInfo _networkInfo;

  ShiftRepositoriesImpl(
      this._remoteSource, this._authLocalSource, this._networkInfo);

  @override
  Future<Either<Failure, List<(int, String)>>> allShift() async {
    if (await _networkInfo.isConnected) {
      try {
        final loginModel = await _authLocalSource.getStoreData();
        final result = await _remoteSource.allShift(loginModel!.tokens.access);
        return Right(result);
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

  @override
  Future<Either<Failure, Unit>> createShift(ShiftModel shift) async {
    if (await _networkInfo.isConnected) {
      try {
        final loginModel = await _authLocalSource.getStoreData();
        await _remoteSource.createShift(shift,loginModel!.tokens.access);
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

  @override
  Future<Either<Failure, Unit>> deleteShift(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final loginModel = await _authLocalSource.getStoreData();
        await _remoteSource.deleteShift(id,loginModel!.tokens.access);
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

  @override
  Future<Either<Failure, ShiftModel>> shiftDetail(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final loginModel = await _authLocalSource.getStoreData();
        final result = await _remoteSource.shiftDetail(id,loginModel!.tokens.access);
        return Right(result);
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

  @override
  Future<Either<Failure, Unit>> updateShift(int id, ShiftModel shift) async {
    if (await _networkInfo.isConnected) {
      try {
        final loginModel = await _authLocalSource.getStoreData();
        await _remoteSource.updateShift(id,shift,loginModel!.tokens.access);
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
