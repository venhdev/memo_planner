import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// => Future<Either<Failure, T>>
/// - [T] Returned when success
/// - [Failure] Returned when failure
typedef ResultEither<T> = Future<Either<Failure, T>>;

/// => Future<Either<Failure, void>>
/// - Nothing will returned when success
/// - [Failure] Returned when failure
typedef ResultVoid = ResultEither<void>;