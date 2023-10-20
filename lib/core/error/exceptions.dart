const String serverExceptionErrorMessage = "Server Error";
const String cacheExceptionErrorMessage = "Cache Error";

class ServerException implements Exception {
  final String message;

  ServerException([this.message = serverExceptionErrorMessage]);
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = serverExceptionErrorMessage]);
}
