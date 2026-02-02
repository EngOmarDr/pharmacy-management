import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';

typedef MyType<T1,T2> = Future<Either<T1, T2>>;

abstract class AuthRepo {
  Future<Either<Failure, LoginModel>> login(String email, String password);

  Future<Either<Failure, Unit>> changePassword(
      String newPassword, String reNewPassword, String currentPassword);

  Future<Either<Failure, Unit>> refreshToken();

  MyType<Failure,Unit> verifyToken();
}
