import 'package:equatable/equatable.dart';

// General failure message
const String failureMessage = 'Something went wrong !!!';
const String serverFailureFailureMessage = 'Server Failure';
const String cacheCacheFailureMessage = 'Cache Failure';
const String networkFailureMessage = '!!! Some thing went wrong with network !!!';

class Failure extends Equatable {
  final String message;

  const Failure([this.message = failureMessage]);

  @override
  List<Object> get props => [message];
}

// General failure message
class ServerFailure extends Failure {
  const ServerFailure([message = serverFailureFailureMessage]);
}

class CacheFailure extends Failure {
  const CacheFailure([message = cacheCacheFailureMessage]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([message = networkFailureMessage]);
}
