const String serverExceptionErrorMessage = 'Server Exception';
const String cacheExceptionErrorMessage = 'Cache Exception';

class ServerException implements Exception {
  ServerException({
    this.code = 'e0',
    this.message = serverExceptionErrorMessage,
  });

  final String code;
  final String message;
}

class CacheException implements Exception {
  CacheException({
    this.message = cacheExceptionErrorMessage,
  });

  final String message;
}
