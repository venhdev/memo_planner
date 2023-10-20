import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// [ResultFuture] will return a [Future] with a return type of [T] or [Failure].
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// [ResultVoid] will return a [Future] with no return type or [Failure].
typedef ResultVoid = ResultFuture<void>;
