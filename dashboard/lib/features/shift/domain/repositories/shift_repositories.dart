import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';

abstract class ShiftRepositories {
  Future<Either<Failure,List<(int, String)>>> allShift();
  Future<Either<Failure,ShiftModel>> shiftDetail(int id);
  Future<Either<Failure,Unit>> createShift(ShiftModel shift);
  Future<Either<Failure,Unit>> deleteShift(int id);
  Future<Either<Failure,Unit>> updateShift(int id,ShiftModel shift);
}