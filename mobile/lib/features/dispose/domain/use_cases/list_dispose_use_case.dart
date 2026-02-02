
import '../repositories/dispose_repositories.dart';

class ListDisposeUseCase {
  final DisposeRepositories repository;

  ListDisposeUseCase(this.repository);

  // Future<Either<Failure, List<Medicine>>> call() =>
  //     repository.listMedicines();
}
