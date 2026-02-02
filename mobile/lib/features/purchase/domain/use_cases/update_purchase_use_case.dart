import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../entities/purchase.dart';
import '../repositories/purchase_repositories.dart';

class UpdatePurchaseUseCase {
  final PurchaseRepositories repository;

  UpdatePurchaseUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
          {required List<Purchase> purchase}) =>
      repository.updatePurchase(purchase);
}
