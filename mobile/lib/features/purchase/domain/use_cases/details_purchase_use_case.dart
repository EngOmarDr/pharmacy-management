
import '../repositories/purchase_repositories.dart';

class DetailsPurchaseUseCase {
  final PurchaseRepositories repository;

  DetailsPurchaseUseCase(this.repository);

  // Future<Either<Failure, Medicine>> call({required int medicineID}) =>
      // repository.detailsPurchase(medicineID);
}
