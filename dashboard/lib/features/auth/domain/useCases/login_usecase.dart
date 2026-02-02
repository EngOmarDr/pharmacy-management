import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';

import '../../data/models/login_model.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginModel>> call(String email, String password) async {
    return await repository.login(email, password);
  }

}
