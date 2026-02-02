import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/dispose/domain/repositories/dispose_repositories.dart';
import 'package:pharmacy/features/purchase/domain/entities/purchase.dart';

class AddDisposeUseCase {
  final DisposeRepositories repository;

  AddDisposeUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required List<Purchase> purchase}) =>
      repository.addDispose(purchase);
}
