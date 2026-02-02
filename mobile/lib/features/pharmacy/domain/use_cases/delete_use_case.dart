import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';

class DeletePharmacyUseCase{
  final PharmacyRepositories repo ;
  const DeletePharmacyUseCase({required this.repo});

  Future<Either<Failure,Unit>> call(int pharmacyId)async => await repo.deletePharmacy(pharmacyId);
}