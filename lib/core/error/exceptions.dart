const String serverExceptionMessage = 'Server Exception';
const String cacheExceptionMessage = 'Cache Exception';
const String formatExceptionMessage = 'Format Exception';

class ServerException implements Exception {
  ServerException({
    this.code = 'e0',
    this.message = serverExceptionMessage,
  });

  final String code;
  final String message;
}

class CacheException implements Exception {
  CacheException({
    this.message = cacheExceptionMessage,
  });

  final String message;
}


// format exception
class FormatException implements Exception {
  FormatException({
    this.message = formatExceptionMessage,
  });

  final String message;
}