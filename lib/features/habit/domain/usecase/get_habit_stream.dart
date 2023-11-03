import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../repository/habit_repository.dart';

@singleton
class GetHabitStreamUC extends UseCaseWithParams<Stream<QuerySnapshot>, UserEntity> {
  GetHabitStreamUC(this._habitRepository);
  final HabitRepository _habitRepository;


  @override
  Stream<QuerySnapshot> call(UserEntity params) {
    return _habitRepository.getHabitStream(params);
  }
}
