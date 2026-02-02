import 'package:dartz/dartz.dart';
import 'package:pharmacy/core/error/failures.dart';
import 'package:pharmacy/features/dispose/domain/entities/dispose_retrieve.dart';

import '../repositories/dispose_repositories.dart';

class RetrieveDisposeUseCase {
  final DisposeRepositories repository;

  RetrieveDisposeUseCase(this.repository);

  Future<Either<Failure, DisposeRetrieve>> call() =>
       repository.retrieveDispose();
}
