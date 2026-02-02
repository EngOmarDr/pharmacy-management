import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy/features/medicine/domain/repositories/medicine_repositories.dart';

class UpdateMedicineUseCase {
  final MedicineRepositories repository;

  UpdateMedicineUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
          {required MedicineModel medicineModel, required int medicineID}) =>
      repository.updateMedicine(medicineModel, medicineID);
}
