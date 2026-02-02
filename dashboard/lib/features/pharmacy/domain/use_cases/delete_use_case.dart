import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/pharmacy/domain/repositories/pharmacy_repo.dart';

class DeletePharmacyUseCase{
  final PharmacyRepositories repo ;
  const DeletePharmacyUseCase({required this.repo});

  Future<Either<Failure,Unit>> call(int pharmacyId)async => await repo.deletePharmacy(pharmacyId);
}