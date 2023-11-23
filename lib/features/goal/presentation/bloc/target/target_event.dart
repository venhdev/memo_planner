part of 'target_bloc.dart';

sealed class TargetEvent extends Equatable {
  const TargetEvent();

  @override
  List<Object> get props => [];
}

class TargetEventInitial extends TargetEvent {}

class TargetEventAdded extends TargetEvent {
  const TargetEventAdded({required this.target});

  final TargetEntity target;
  @override
  List<Object> get props => [target];
}

class TargetEventDeleted extends TargetEvent {
  const TargetEventDeleted(this.target);

  final TargetEntity target;
  @override
  List<Object> get props => [target];
}

class TargetEventUpdated extends TargetEvent {
  const TargetEventUpdated(this.target);

  final TargetEntity target;
  @override
  List<Object> get props => [target];
}
