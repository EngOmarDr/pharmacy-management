import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';

class DetailsPharmacyUseCase {
  final PharmacyRepositories repository;
  const DetailsPharmacyUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(int pharmacyId) async =>
      await repository.pharmacyDetail(pharmacyId);
}
