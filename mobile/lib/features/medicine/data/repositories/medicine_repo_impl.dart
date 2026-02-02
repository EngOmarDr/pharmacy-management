import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/core/network_info.dart';
import 'package:pharmacy/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy/features/medicine/domain/entities/medicine.dart';

import '../../../auth/data/dataSources/auth_local_source.dart';
import '../../domain/repositories/medicine_repositories.dart';
import '../data_source/medicine_remote_source.dart';

class MedicineRepoImpl implements MedicineRepositories {
  final MedicineRemoteSource medicineRemoteSource;

  final AuthLocalSource authLocalSource;
  final NetworkInfo networkInfo;

  const MedicineRepoImpl(
      {required this.authLocalSource,
      required this.networkInfo,
      required this.medicineRemoteSource});

  @override
  Future<Either<Failure, Unit>> createMedicine(MedicineModel medicine) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await medicineRemoteSource.createMedicine(
            medicine, authModel!.tokens.access);
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
  Future<Either<Failure, Unit>> deleteMedicine(int medicineID) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await medicineRemoteSource.deleteMedicine(
            medicineID, authModel!.tokens.access);
        return const Right(unit);
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
  Future<Either<Failure, Medicine>> detailsMedicine(int medicineID) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final medRes = await medicineRemoteSource.detailsMedicine(
            medicineID, authModel!.tokens.access);
        return Right(medRes);
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
  Future<Either<Failure, List<Medicine>>> listMedicines() async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final result =
            await medicineRemoteSource.listMedicines(authModel!.tokens.access);
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

  @override
  Future<Either<Failure, Unit>> updateMedicine(
      MedicineModel medicine, int medicineID) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await medicineRemoteSource.updateMedicine(
            medicine, medicineID, authModel!.tokens.access);
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
}
