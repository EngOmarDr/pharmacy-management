import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/dispose/domain/repositories/dispose_repositories.dart';

import '../../../purchase/domain/entities/purchase.dart';

class UpdateDisposeUseCase {
  final DisposeRepositories repository;

  UpdateDisposeUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
          {required List<Purchase> purchase}) =>
      repository.updateDispose(purchase);
}
