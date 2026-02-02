import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';

typedef MyType<T1,T2> = Future<Either<T1, T2>>;

abstract class AuthRepo {
  Future<Either<Failure, LoginModel>> login(String email, String password);

  Future<Either<Failure, Unit>> changePassword(
      String newPassword, String reNewPassword, String currentPassword);

  Future<Either<Failure, Unit>> refreshToken();

  MyType<Failure,Unit> verifyToken();
}
