import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/medicine/domain/repositories/medicine_repositories.dart';

class DeleteMedicineUseCase {
  final MedicineRepositories repository;

  DeleteMedicineUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int medicineID}) =>
      repository.deleteMedicine(medicineID);
}
