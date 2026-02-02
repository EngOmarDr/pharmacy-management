abstract class Failure {}

class ServerFailure extends Failure {}

class OfflineFailure extends Failure {}

class CacheFailure extends Failure{}

class DetailsFailure extends Failure{
  final String message;

  DetailsFailure(this.message);
}

class DataNotCompleteFailure extends Failure{
  final String message;

  DataNotCompleteFailure(this.message);
}

class LoginFailure extends Failure{}
