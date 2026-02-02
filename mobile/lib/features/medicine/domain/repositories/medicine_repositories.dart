import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';

import '../../data/models/medicine_model.dart';
import '../entities/medicine.dart';

abstract class MedicineRepositories {
  Future<Either<Failure, Unit>> createMedicine(MedicineModel medicine);

  Future<Either<Failure, Unit>> updateMedicine(
      MedicineModel medicine, int medicineID);

  Future<Either<Failure, Unit>> deleteMedicine(int medicineID);

  Future<Either<Failure, Medicine>> detailsMedicine(int medicineID);

  Future<Either<Failure, List<Medicine>>> listMedicines();
}
