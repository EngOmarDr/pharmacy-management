import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../entities/purchase.dart';
import '../repositories/purchase_repositories.dart';

class DeletePurchaseUseCase {
  final PurchaseRepositories repository;

  DeletePurchaseUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required List<Purchase> purchase}) =>
      repository.deletePurchase(purchase);
}
