import 'package:equatable/equatable.dart';

enum Code { unknown, unauthorized, unauthenticated, notFound }

// General failure message
const String failureMessage = 'Something went wrong !!!';
const String userFailureFailureMessage = failureMessage;
const String serverFailureFailureMessage = 'Server Failure';
const String cacheCacheFailureMessage = 'Cache Failure';
const String networkFailureMessage = 'Network Failure';

class Failure extends Equatable {
  const Failure({
    this.code = 'unknown-failure',
    this.message = failureMessage,
  });

  final String code;
  final String message;

  @override
  List<Object> get props => [code, message];
}

// General failure message
class UserFailure extends Failure {
  const UserFailure({
    super.code = 'user-failure',
    super.message,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.code = 'server-failure',
    super.message = serverFailureFailureMessage,
  });
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    super.code = 'firebase-failure',
    super.message = serverFailureFailureMessage,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.code = 'cache-failure',
    super.message = cacheCacheFailureMessage,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.code = 'network-failure',
    super.message = networkFailureMessage,
  });
}
