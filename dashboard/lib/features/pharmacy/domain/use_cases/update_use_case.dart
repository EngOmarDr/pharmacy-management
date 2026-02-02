import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/pharmacy/data/models/pharmacy_model.dart';
import 'package:dashboard/features/pharmacy/domain/repositories/pharmacy_repo.dart';


class UpdatePharmacyUseCase {
  final PharmacyRepositories repo;

  UpdatePharmacyUseCase({required this.repo});

  Future<Either<Failure, Unit>> call({required PharmacyModel pharmacy}) async =>
      await repo.updatePharmacy(pharmacy);
}
