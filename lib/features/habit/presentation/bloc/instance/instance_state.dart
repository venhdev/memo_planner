part of 'instance_bloc.dart';

sealed class InstanceState extends Equatable {
  const InstanceState();

  @override
  List<Object> get props => [];
}

final class InstanceInitial extends InstanceState {}

final class InstanceLoading extends InstanceState {}

final class InstanceActionSuccess extends InstanceState {
  const InstanceActionSuccess({
    this.message,
  });
  final String? message;
}

final class InstanceActionFail extends InstanceState {
  const InstanceActionFail({
    this.message,
  });
  final String? message;
}