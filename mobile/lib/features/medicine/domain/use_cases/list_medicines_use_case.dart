import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/medicine/domain/entities/medicine.dart';
import 'package:pharmacy/features/medicine/domain/repositories/medicine_repositories.dart';

class ListMedicineUseCase {
  final MedicineRepositories repository;

  ListMedicineUseCase(this.repository);

  Future<Either<Failure, List<Medicine>>> call() =>
      repository.listMedicines();
}
