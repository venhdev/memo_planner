import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/habit_instance_entity.dart';
import '../repository/habit_repository.dart';

@singleton
class ChangeHabitInstanceStatusUC
    extends UseCaseWithParams<ResultVoid, ChangeHabitInstanceStatusParams> {
  ChangeHabitInstanceStatusUC(this._habitRepository);
  final HabitRepository _habitRepository;
  @override
  ResultVoid call(ChangeHabitInstanceStatusParams params) async {
    return await _habitRepository.changeHabitInstanceStatus(
      params.instance,
      params.status,
    );
  }
}

class ChangeHabitInstanceStatusParams extends Equatable {
  const ChangeHabitInstanceStatusParams({
    required this.instance,
    required this.status,
  });

  final HabitInstanceEntity instance;
  final bool status;

  @override
  List<Object> get props => [instance, status];
}
