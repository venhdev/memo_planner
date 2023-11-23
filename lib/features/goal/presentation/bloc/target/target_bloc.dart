import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/enum.dart';
import '../../../../../core/constants/typedef.dart';
import '../../../../authentication/domain/usecase/get_current_user.dart';
import '../../../domain/entities/target_entity.dart';
import '../../../domain/usecase/usecases.dart';

part 'target_event.dart';
part 'target_state.dart';

@injectable
class TargetBloc extends Bloc<TargetEvent, TargetState> {
  TargetBloc(
    this._getCurrentUserUC,
    this._getTargetStreamUC,
    this._addTargetUC,
    this._updateTargetUC,
    this._deleteTargetUC,
  ) : super(const TargetState.initial()) {
    on<TargetEventInitial>(_onInitial);
    on<TargetEventAdded>(_onAdded);
    on<TargetEventDeleted>(_onDeleted);
    on<TargetEventUpdated>(_onUpdated);
  }

  final GetCurrentUserUC _getCurrentUserUC;
  final GetTargetStreamUC _getTargetStreamUC;
  final AddTargetUC _addTargetUC;
  final UpdateTargetUC _updateTargetUC;
  final DeleteTargetUC _deleteTargetUC;

  void _onInitial(
    TargetEventInitial event,
    Emitter<TargetState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    var user = _getCurrentUserUC();
    if (user != null) {
      var streamEither = await _getTargetStreamUC(user.email!);
      streamEither.fold(
        (l) => emit(state.copyWith(status: BlocStatus.failure, message: l.message)),
        (stream) => emit(state.copyWith(status: BlocStatus.loaded, stream: stream)),
      );
    } else {
      emit(state.copyWith(status: BlocStatus.failure, message: 'User not found'));
    }
  }

  void _onAdded(
    TargetEventAdded event,
    Emitter<TargetState> emit,
  ) async {
    final rs = await _addTargetUC(event.target);
    rs.fold(
      (l) => emit(state.copyWith(status: BlocStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: BlocStatus.success, message: 'Target added')),
    );
  }

  void _onDeleted(
    TargetEventDeleted event,
    Emitter<TargetState> emit,
  ) async {
    final rs = await _deleteTargetUC(event.target);
    rs.fold(
      (l) => emit(state.copyWith(status: BlocStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: BlocStatus.success, message: 'Target deleted')),
    );
  }

  void _onUpdated(
    TargetEventUpdated event,
    Emitter<TargetState> emit,
  ) async {
    final rs = await _updateTargetUC(event.target);
    rs.fold(
      (l) => emit(state.copyWith(status: BlocStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: BlocStatus.success, message: 'Target updated')),
    );
  }
}
