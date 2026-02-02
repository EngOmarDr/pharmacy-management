import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../entities/purchase.dart';


abstract class PurchaseRepositories {
  Future<Either<Failure, Unit>> addPurchase(List<Purchase> purchase);

  Future<Either<Failure, Unit>> updatePurchase(
      List<Purchase> purchase);

  Future<Either<Failure, Unit>> deletePurchase(List<Purchase> purchase);

  // Future<Either<Failure, PurchaseModel>> detailsPurchase(int medicineID);

  // Future<Either<Failure, List<Medicine>>> listPurchase();
}
