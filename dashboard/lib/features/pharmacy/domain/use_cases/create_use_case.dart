import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/pharmacy/domain/repositories/pharmacy_repo.dart';

import '../../data/models/pharmacy_model.dart';

class CreatePharmacyUseCase {
  final PharmacyRepositories repo;

  CreatePharmacyUseCase({required this.repo});

  Future<Either<Failure, Unit>> call({required PharmacyModel pharmacy}) async =>
      await repo.createPharmacy(pharmacy);
}
