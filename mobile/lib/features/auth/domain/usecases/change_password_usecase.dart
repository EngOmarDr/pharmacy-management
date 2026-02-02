import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../repositories/auth_repo.dart';

class ChangePasswordUseCase {
  AuthRepo repository;
  ChangePasswordUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(
      String newPassword, String reNewPassword, String currentPassword) async {
    return await repository.changePassword(
        newPassword, reNewPassword, currentPassword);
  }
}
