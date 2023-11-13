import 'package:cloud_firestore/cloud_firestore.dart';
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

/// => Stream<QuerySnapshot<Map<String, dynamic>>>
/// - This is return of .snapshots() method of [CollectionReference]
typedef SQuerySnapshot = Stream<QuerySnapshot<Map<String, dynamic>>>;

