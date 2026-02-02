import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';

import '../repositories/shift_repositories.dart';

class DeleteShiftUseCase {
  final ShiftRepositories repo;

  DeleteShiftUseCase({required this.repo});

  Future<Either<Failure,Unit>> call({required int id}){
    return repo.deleteShift(id);
  }
}