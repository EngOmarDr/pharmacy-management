import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/exceptions.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/core/network_info.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_local_source.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_remote_source.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final AuthRemoteSource remoteSource;
  final AuthLocalSource localSource;
  final NetworkInfo networkInfo;

  AuthRepoImp(
      {required this.remoteSource,
      required this.localSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, LoginModel>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        LoginModel loginModal = await remoteSource.login(email, password);
        await localSource.storeAuthData(loginModal);
        print(loginModal.tokens.access);
        await remoteSource.registerDevice(loginModal.pharmacyId ?? 1,loginModal.tokens.access);
        return Right(loginModal);
      } on DetailsException catch(e){
        return Left(DetailsFailure(e.detail));
      } on CacheException {
        return Left(CacheFailure());
      } on DataNotCompleteException catch (exc) {
        return Left(DataNotCompleteFailure(exc.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(
      String newPassword, String reNewPassword, String currentPassword) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await localSource.getStoreData();
        final newAccessToken = await remoteSource.refreshToken(loginModel);
        LoginModel newLoginModel = loginModel!.copyWith(
            tokens: TokensModel(
                refresh: loginModel.tokens.refresh, access: newAccessToken));
        await localSource.storeAuthData(newLoginModel);
        return const Right(unit);
      } on TokensNotValidException {
        return Left(LoginFailure());
      } on CacheException {
        return Left(CacheFailure());
      }on Exception {
        return Left(LoginFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  MyType<Failure, Unit> verifyToken() async {
    if (await networkInfo.isConnected) {
      try {
        final loginModel = await localSource.getStoreData();
        await remoteSource.verifyToken(loginModel!.tokens.access);
        return const Right(unit);
      } on AccessNotValidException {
        return await refreshToken();
      } on Exception {
        return await refreshToken();
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
