import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/habit_instance_entity.dart';
import '../repository/habit_instance_repository.dart';

@singleton
class ChangeHabitInstanceStatusUC
    extends UseCaseWithParams<ResultVoid, ChangeHabitInstanceStatusParams> {
  ChangeHabitInstanceStatusUC(this._habitInstanceRepository);
  final HabitInstanceRepository _habitInstanceRepository;
  @override
  ResultVoid call(ChangeHabitInstanceStatusParams params) async {
    return await _habitInstanceRepository.changeHabitInstanceStatus(
      params.instance,
      params.completed,
    );
  }
}

class ChangeHabitInstanceStatusParams extends Equatable {
  const ChangeHabitInstanceStatusParams({
    required this.instance,
    required this.completed,
  });

  final HabitInstanceEntity instance;
  final bool completed;

  @override
  List<Object> get props => [instance, completed];
}
