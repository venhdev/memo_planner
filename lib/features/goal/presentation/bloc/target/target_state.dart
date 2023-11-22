part of 'target_bloc.dart';

sealed class TargetState extends Equatable {
  const TargetState();
  
  @override
  List<Object> get props => [];
}

final class TargetInitial extends TargetState {}
