abstract class Failure {}

class ServerFailure extends Failure {}

class OfflineFailure extends Failure {}

class CacheFailure extends Failure {}

class DetailsFailure extends Failure {
  final String error;

  DetailsFailure({required this.error});
}

class LoginFailure extends Failure {}

class UnKnownFailure extends Failure {}
