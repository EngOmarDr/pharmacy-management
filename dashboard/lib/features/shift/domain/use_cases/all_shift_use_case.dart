import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';

import '../repositories/shift_repositories.dart';

class AllShiftUseCase {
  final ShiftRepositories repo;

  AllShiftUseCase({required this.repo});

  Future<Either<Failure,List<(int id,String name)>>> call(){
    return repo.allShift();
  }
}