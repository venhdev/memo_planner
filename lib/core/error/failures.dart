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
    String code = 'user-failure',
    String message = userFailureFailureMessage,
  }) : super(code: code, message: message);
}

class ServerFailure extends Failure {
  const ServerFailure({
    String code = 'server-failure',
    String message = serverFailureFailureMessage,
  }) : super(code: code, message: message);
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    String code = 'firebase-failure',
    String message = serverFailureFailureMessage,
  }) : super(code: code, message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String code = 'cache-failure',
    String message = cacheCacheFailureMessage,
  }) : super(code: code, message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String code = 'network-failure',
    String message = networkFailureMessage,
  }) : super(code: code, message: message);
}
