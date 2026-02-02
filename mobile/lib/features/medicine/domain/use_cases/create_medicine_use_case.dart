import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy/features/medicine/domain/repositories/medicine_repositories.dart';

class CreateMedicineUseCase {
  final MedicineRepositories repository;

  CreateMedicineUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required MedicineModel medicineModel}) =>
      repository.createMedicine(medicineModel);
}
