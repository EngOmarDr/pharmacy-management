class EmptyStorageException implements Exception{}

class DetailsException implements Exception{
  final String detail;
  DetailsException(this.detail);
}

class CacheException implements Exception{}

class DataNotCompleteException implements Exception{
  final String message;
  DataNotCompleteException(this.message);
}

class ServerErrorException implements Exception{}

class TokensNotValidException implements Exception{}

class AccessNotValidException implements Exception{}