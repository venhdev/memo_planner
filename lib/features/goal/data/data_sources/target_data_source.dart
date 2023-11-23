import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/constants.dart';

import '../../../../core/constants/typedef.dart';
import '../../domain/entities/target_entity.dart';
import '../models/target_model.dart';

abstract class TargetDataSource {
  Future<void> addTarget(TargetEntity target);
  Future<void> updateTarget(TargetEntity target);
  Future<void> deleteTarget(TargetEntity target);
  Future<SQuerySnapshot> getTargetStream(String email);
}

@Singleton(as: TargetDataSource)
class TargetDataSourceImpl extends TargetDataSource {
  TargetDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  @override
  Future<void> addTarget(TargetEntity target) async {
    var targetCollRef = _firestore.collection(pathToUsers).doc(target.creator!.email).collection(pathToTargets);
    var targetId = targetCollRef.doc().id;
    target = target.copyWith(targetId: targetId);
    await targetCollRef.doc(targetId).set(TargetModel.fromEntity(target).toDocument());
  }

  @override
  Future<void> deleteTarget(TargetEntity target) async {
    var targetDocRef =
        _firestore.collection(pathToUsers).doc(target.creator!.email).collection(pathToTargets).doc(target.targetId);

    await targetDocRef.delete();
  }

  @override
  Future<SQuerySnapshot> getTargetStream(String email) async {
    return _firestore.collection(pathToUsers).doc(email).collection(pathToTargets).snapshots();
  }

  @override
  Future<void> updateTarget(TargetEntity target) async {
    var targetDocRef =
        _firestore.collection(pathToUsers).doc(target.creator!.email).collection(pathToTargets).doc(target.targetId);

    await targetDocRef.update(TargetModel.fromEntity(target).toDocument());
  }
}
