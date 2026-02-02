import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';


class UpdatePharmacyUseCase {
  final PharmacyRepositories repo;

  UpdatePharmacyUseCase({required this.repo});

  Future<Either<Failure, Unit>> call(PharmacyModel pharmacy, int pharmacyId) async =>
      await repo.updatePharmacy(pharmacy,pharmacyId);
}
