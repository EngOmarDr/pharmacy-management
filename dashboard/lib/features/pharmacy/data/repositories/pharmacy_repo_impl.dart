import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/exceptions.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/core/network_info.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
import 'package:dashboard/features/pharmacy/data/data_source/remote_source.dart';
import 'package:dashboard/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:dashboard/features/pharmacy/domain/repositories/pharmacy_repo.dart';

import '../../domain/entities/pharmacy.dart';

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
      }on DetailsException catch(error){
        return Left(DetailsFailure(error: error.detail));
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
  Future<Either<Failure, Unit>> updatePharmacy(PharmacyModel pharmacy) async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        await pharmacyRemoteSource.updatePharmacy(pharmacy, authModel!.tokens.access);
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
  Future<Either<Failure, List<Pharmacy>>> allPharmacies() async {
    if (await networkInfo.isConnected) {
      try {
        final authModel = await authLocalSource.getStoreData();
        final List<Pharmacy> result =  await pharmacyRemoteSource.allPharmacies(authModel!.tokens.access);
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