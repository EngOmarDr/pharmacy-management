import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/exceptions.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/core/network_info.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_remote_source.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';
import 'package:dashboard/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final AuthRemoteSource remoteSource;
  final AuthLocalSource localSource;
  final NetworkInfo networkInfo;

  AuthRepoImp(
      {required this.remoteSource,
      required this.localSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, LoginModel>> login(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        LoginModel loginModal = await remoteSource.login(email, password);
        await localSource.storeAuthData(loginModal);
        return Right(loginModal);
      } on ServerErrorException {
        return Left(ServerFailure());
      } on DetailsException catch(e){
        return Left(DetailsFailure(error: e.detail));
      } on CacheException {
        return Left(CacheFailure());
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
        await remoteSource.verifyToken(loginModel?.tokens.access ?? '');
        return const Right(unit);
      } on AccessNotValidException {
        return await refreshToken();
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
