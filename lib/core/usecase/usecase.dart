import '../constants/typedef.dart';

/// - [Type] is the wanted return type of the use case.
/// - [Params] is the parameters that the use case needs to run.
/// 
/// => [Future<Either<Failure, Type>>]
abstract class UseCaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);
}

/// [Type] is the wanted return type of the use case.
///
/// => [Future<Either<Failure, Type>>]
abstract class UseCaseNoParams<Type> {
  ResultFuture<Type> call();
}

/// [Type] is the return type of the use case and can be null.
///
/// => [Future<Type?>]
abstract class UseCaseNoParamNull<Type> {
  Future<Type?> call();
}

// Pass [NoParams] if the use case doesn't need any parameters
/// [NoParams] is a class that will be used when the use case doesn't need any parameters.
// class NoParams extends Equatable {
//   @override
//   List<Object> get props => [];
// }
