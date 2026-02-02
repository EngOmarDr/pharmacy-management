import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';

class AllPharmaciesUseCase {
  final PharmacyRepositories repository;

  AllPharmaciesUseCase({required this.repository});

  Future<Either<Failure,List<dynamic>>> call(){
    return repository.allPharmacies();
  }
}