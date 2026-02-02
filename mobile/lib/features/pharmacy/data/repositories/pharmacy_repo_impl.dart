import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/core/network_info.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_local_source.dart';
import 'package:pharmacy/features/pharmacy/data/data_source/remote_source.dart';
import 'package:pharmacy/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';

class PharmacyRepoImpl implements PharmacyRepositories{

  final PharmacyRemoteSource pharmacyRemoteSource ;
  final AuthLocalSource authLocalSource;
  final NetworkInfo networkInfo;
  const PharmacyRepoImpl({required this.authLocalSource, required this.networkInfo, required this.pharmacyRemoteSource});

  @override
  Future<Either<Failure, Unit>> createPharmacy(PharmacyModel pharmacy) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await pharmacyRemoteSource.createPharmacy(pharmacy, authModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      }on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePharmacy(int pharmacyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await pharmacyRemoteSource.deletePharmacy(pharmacyId, authModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      }on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> pharmacyDetail(int pharmacyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await pharmacyRemoteSource.pharmacyDetail(pharmacyId, authModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      }on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePharmacy(PharmacyModel pharmacy, int pharmacyId) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await pharmacyRemoteSource.updatePharmacy(pharmacy, pharmacyId, authModel!.tokens.access);
        return const Right(unit);
      } on ServerErrorException {
        return Left(ServerFailure());
      }on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> allPharmacies() async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final result =  await pharmacyRemoteSource.allPharmacies(authModel!.tokens.access);
        return Right(result);
      } on ServerErrorException {
        return Left(ServerFailure());
      }on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

}