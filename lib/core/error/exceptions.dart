const String serverExceptionErrorMessage = "Server Exception";
const String cacheExceptionErrorMessage = "Cache Exception";

class ServerException implements Exception {
  final String code;
  final String message;

  ServerException({this.code = 'e0', this.message = serverExceptionErrorMessage});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = cacheExceptionErrorMessage});
}
