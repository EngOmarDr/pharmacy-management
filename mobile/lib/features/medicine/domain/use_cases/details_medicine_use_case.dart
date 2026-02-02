import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/medicine/domain/entities/medicine.dart';
import 'package:pharmacy/features/medicine/domain/repositories/medicine_repositories.dart';

class DetailsMedicineUseCase {
  final MedicineRepositories repository;

  DetailsMedicineUseCase(this.repository);

  Future<Either<Failure, Medicine>> call({required int medicineID}) =>
      repository.detailsMedicine(medicineID);
}
