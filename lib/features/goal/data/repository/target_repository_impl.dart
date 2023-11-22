import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/target_entity.dart';
import '../../domain/repository/target_repository.dart';
import '../data_sources/target_data_source.dart';

@Singleton(as: TargetRepository)
class TargetRepositoryImpl extends TargetRepository {
  TargetRepositoryImpl(this.targetDataSource);
  final TargetDataSource targetDataSource;
  @override
  ResultVoid addTarget(TargetEntity target) async {
    try {
      return Right(await targetDataSource.addTarget(target));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('General Exception: type: ${e.runtimeType} message: ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTarget(TargetEntity target) async {
    try {
      return Right(await targetDataSource.deleteTarget(target));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('General Exception: type: ${e.runtimeType} message: ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultEither<SQuerySnapshot> getTargetStream(String uid) async {
    try {
      return Right(await targetDataSource.getTargetStream(uid));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('General Exception: type: ${e.runtimeType} message: ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultVoid updateTarget(TargetEntity target) async {
    try {
      return Right(await targetDataSource.updateTarget(target));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('General Exception: type: ${e.runtimeType} message: ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }
}
