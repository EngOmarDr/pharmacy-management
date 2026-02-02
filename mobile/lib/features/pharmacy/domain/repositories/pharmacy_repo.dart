import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../../data/models/pharmacy_model.dart';

abstract class PharmacyRepositories {
  Future<Either<Failure,Unit>> createPharmacy(PharmacyModel pharmacy);
  Future<Either<Failure,Unit>> updatePharmacy(PharmacyModel pharmacy, int pharmacyId);
  Future<Either<Failure,Unit>> deletePharmacy(int pharmacyId);
  Future<Either<Failure,Unit>> pharmacyDetail(int pharmacyId);
  Future<Either<Failure,List<dynamic>>> allPharmacies();
}