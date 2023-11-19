/*
goal#target:
- tid:String --target id
- summary:String
- description:String
- target:int --[measurable] e.g. 20
- progress:int --[x]=x/target*100
- unit:String --step, point
- created:User
- kind:String = 'goal#target'
*/
import 'package:equatable/equatable.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';

class TargetEntity extends Equatable {
  const TargetEntity({
    required this.targetId,
    required this.summary,
    required this.description,
    required this.target,
    required this.progress,
    required this.unit,
    required this.creator,
    this.kind = 'goal#target',
  });

  final String? targetId; // goal id
  final String? summary;
  final String? description;
  final UserEntity? creator;

  final int? target;
  final int? progress;
  final String? unit;
  
  final String kind;

  @override
  List<Object?> get props => [
        targetId,
        summary,
        description,
        target,
        progress,
        unit,
        creator,
        kind,
      ];
}