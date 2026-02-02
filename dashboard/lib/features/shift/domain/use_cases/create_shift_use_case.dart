import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';

import '../repositories/shift_repositories.dart';

class CreateShiftUseCase {
  final ShiftRepositories repo;

  CreateShiftUseCase({required this.repo});

  Future<Either<Failure,Unit>> call({required ShiftModel shift}){
    return repo.createShift(shift);
  }
}