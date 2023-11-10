import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';

import '../../../../core/constants/typedef.dart';
import '../repository/habit_instance_repository.dart';

@singleton
class AddHabitInstanceUC
    extends UseCaseWithParams<ResultVoid, AddHabitInstanceParams> {
  AddHabitInstanceUC(this._habitInstanceRepository);
  final HabitInstanceRepository _habitInstanceRepository;
  @override
  ResultVoid call(AddHabitInstanceParams params) async {
    return await _habitInstanceRepository.addHabitInstance(params.habit, params.date);
  }
}

class AddHabitInstanceParams extends Equatable {
  const AddHabitInstanceParams({required this.habit, required this.date});
  final HabitEntity habit;
  final DateTime date;

  @override
  List<Object?> get props => [habit, date];
}
