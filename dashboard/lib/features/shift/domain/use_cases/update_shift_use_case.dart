import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';

import '../repositories/shift_repositories.dart';

class UpdateShiftUseCase {
  final ShiftRepositories repo;

  UpdateShiftUseCase({required this.repo});

  Future<Either<Failure,Unit>> call({required int id,required ShiftModel shift}){
    return repo.updateShift(id,shift);
  }
}