import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'target_event.dart';
part 'target_state.dart';

class TargetBloc extends Bloc<TargetEvent, TargetState> {
  TargetBloc() : super(TargetInitial()) {
    on<TargetEvent>((event, emit) {});
  }
}
