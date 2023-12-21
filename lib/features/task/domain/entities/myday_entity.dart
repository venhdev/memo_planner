// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class MyDayEntity extends Equatable {
  const MyDayEntity({
    required this.lid,
    required this.tid,
    required this.created,
    this.keep = false,
  });

  final String lid;
  final String tid;
  final DateTime created;
  final bool keep;

  @override
  List<Object> get props => [lid, tid, created, keep];

  @override
  bool get stringify => true;

  MyDayEntity copyWith({
    String? lid,
    String? tid,
    DateTime? created,
    bool? keep,
  }) {
    return MyDayEntity(
      lid: lid ?? this.lid,
      tid: tid ?? this.tid,
      created: created ?? this.created,
      keep: keep ?? this.keep,
    );
  }
}
