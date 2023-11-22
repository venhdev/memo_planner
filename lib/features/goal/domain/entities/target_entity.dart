/*
goal#target:
- targetId:String --target id
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

  //copyWith
  TargetEntity copyWith({
    String? targetId,
    String? summary,
    String? description,
    int? target,
    int? progress,
    String? unit,
    UserEntity? creator,
    String? kind,
  }) {
    return TargetEntity(
      targetId: targetId ?? this.targetId,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      unit: unit ?? this.unit,
      creator: creator ?? this.creator,
      kind: kind ?? this.kind,
    );
  }

}
