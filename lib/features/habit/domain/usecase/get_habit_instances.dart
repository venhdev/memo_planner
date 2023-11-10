import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/habit_entity.dart';
import '../repository/habit_instance_repository.dart';

@singleton
class GetHabitInstanceStreamUC
    extends UseCaseWithParams<SQuerySnapshot, GetHabitInstanceParams> {
  GetHabitInstanceStreamUC(this._habitInstanceRepository);

  final HabitInstanceRepository _habitInstanceRepository;
  @override
  SQuerySnapshot call(GetHabitInstanceParams params) {
    return _habitInstanceRepository.getHabitInstanceStream(
      params.habit,
      params.focusDate,
    );
  }
}

class GetHabitInstanceParams extends Equatable {
  const GetHabitInstanceParams({required this.habit, required this.focusDate});
  final HabitEntity habit;
  final DateTime focusDate;

  @override
  List<Object?> get props => [habit, focusDate];
}
