import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';

import '../../data/models/pharmacy_model.dart';
import '../entities/pharmacy.dart';

abstract class PharmacyRepositories {
  Future<Either<Failure,Unit>> createPharmacy(PharmacyModel pharmacy);
  Future<Either<Failure,Unit>> updatePharmacy(PharmacyModel pharmacy);
  Future<Either<Failure,Unit>> deletePharmacy(int pharmacyId);
  Future<Either<Failure,Unit>> pharmacyDetail(int pharmacyId);
  Future<Either<Failure,List<Pharmacy>>> allPharmacies();
}