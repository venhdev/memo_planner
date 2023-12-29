import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../repository/habit_repository.dart';

@singleton
class GetHabitStreamUC extends UseCaseWithParams<SQuerySnapshot, UserEntity> {
  GetHabitStreamUC(this._habitRepository);
  final HabitRepository _habitRepository;


  @override
  SQuerySnapshot call(UserEntity params) {
    return _habitRepository.getHabitStream(params);
  }
}
