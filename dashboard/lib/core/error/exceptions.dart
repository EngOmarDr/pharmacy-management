class EmptyStorageException implements Exception{}

class DetailsException implements Exception{
  final String detail;
  DetailsException({required this.detail});
}

class CacheException implements Exception{}

class ServerErrorException implements Exception{}

class TokensNotValidException implements Exception{}

class AccessNotValidException implements Exception{}