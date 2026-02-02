import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/pharmacy/domain/repositories/pharmacy_repo.dart';

import '../entities/pharmacy.dart';

class AllPharmaciesUseCase {
  final PharmacyRepositories repository;

  AllPharmaciesUseCase({required this.repository});

  Future<Either<Failure,List<Pharmacy>>> call(){
    return repository.allPharmacies();
  }
}