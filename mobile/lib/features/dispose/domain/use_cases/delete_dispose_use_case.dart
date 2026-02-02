import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../../../purchase/domain/entities/purchase.dart';
import '../repositories/dispose_repositories.dart';

class DeleteDisposeUseCase {
  final DisposeRepositories repository;

  DeleteDisposeUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required List<Purchase> purchase}) =>
      repository.deleteDispose(purchase);
}
