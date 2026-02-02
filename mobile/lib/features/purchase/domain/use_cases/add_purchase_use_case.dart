
import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/purchase/domain/entities/purchase.dart';

import '../repositories/purchase_repositories.dart';

class AddPurchaseUseCase {
  final PurchaseRepositories repository;

  AddPurchaseUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required List<Purchase> purchase}) =>
      repository.addPurchase(purchase);
}
