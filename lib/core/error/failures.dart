import 'package:equatable/equatable.dart';

// General failure message
const String failureMessage = 'Something went wrong !!!';
const String serverFailureFailureMessage = 'Server Failure';
const String cacheCacheFailureMessage = 'Cache Failure';
const String networkFailureMessage = 'Network Failure';

class Failure extends Equatable {
  final String code;
  final String message;

  const Failure({this.code = '1000', this.message = failureMessage});

  @override
  List<Object> get props => [code, message];
}

// General failure message
class ServerFailure extends Failure {

  const ServerFailure({code = '2000', message = serverFailureFailureMessage})
      : super(code: code, message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({code = '3000', message = cacheCacheFailureMessage})
      : super(code: code, message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({code = '4000', message = networkFailureMessage})
      : super(code: code, message: message);
}
