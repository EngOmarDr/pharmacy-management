import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';

import '../repositories/shift_repositories.dart';

class ShiftDetailUseCase {
  final ShiftRepositories repo;

  ShiftDetailUseCase({required this.repo});

  Future<Either<Failure,ShiftModel>> call({required int id}){
    return repo.shiftDetail(id);
  }
}