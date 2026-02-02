
import '../repositories/purchase_repositories.dart';

class ListPurchaseUseCase {
  final PurchaseRepositories repository;

  ListPurchaseUseCase(this.repository);

  // Future<Either<Failure, List<Medicine>>> call() =>
      // repository.listPurchase();
}
