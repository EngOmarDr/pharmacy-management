import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/dispose/domain/entities/dispose_retrieve.dart';

import '../../../purchase/domain/entities/purchase.dart';

abstract class DisposeRepositories {
  Future<Either<Failure, Unit>> addDispose(List<Purchase> disposeList);

  Future<Either<Failure, Unit>> updateDispose(
      List<Purchase> disposeList);

  Future<Either<Failure, Unit>> deleteDispose(List<Purchase> disposeList);

  Future<Either<Failure, DisposeRetrieve>> retrieveDispose();

  // Future<Either<Failure, List<Medicine>>> listDispose();
}
