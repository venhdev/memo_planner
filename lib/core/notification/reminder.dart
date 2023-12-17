// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ReminderMethod { email, popup }

class Reminder {
  final int? rid;
  final bool useDefault;
  final DateTime? scheduledTime;
  final List<OverrideReminder>? overrides;

  Reminder({
    this.rid,
    this.useDefault = true,
    this.scheduledTime,
    this.overrides,
  });

  Reminder copyWith({
    int? rid,
    bool? useDefault,
    DateTime? scheduledTime,
    List<OverrideReminder>? overrides,
  }) {
    return Reminder(
      rid: rid ?? this.rid,
      useDefault: useDefault ?? this.useDefault,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      overrides: overrides ?? this.overrides,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rid': rid,
      'useDefault': useDefault,
      'scheduledTime': scheduledTime?.millisecondsSinceEpoch,
      'overrides': overrides?.map((x) => x.toMap()).toList(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      rid: map['rid'] != null ? map['rid'] as int : null,
      useDefault: map['useDefault'] as bool,
      scheduledTime:
          map['scheduledTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['scheduledTime'] as int) : null,
      overrides: map['overrides'] != null
          ? List<OverrideReminder>.from(
              (map['overrides'] as List<int>).map<OverrideReminder?>(
                (x) => OverrideReminder.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) => Reminder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Reminder(rid: $rid, useDefault: $useDefault, scheduledTime: $scheduledTime, overrides: $overrides)';

  @override
  bool operator ==(covariant Reminder other) {
    if (identical(this, other)) return true;

    return other.rid == rid &&
        other.useDefault == useDefault &&
        other.scheduledTime == scheduledTime &&
        listEquals(other.overrides, overrides);
  }

  @override
  int get hashCode {
    return rid.hashCode ^ useDefault.hashCode ^ scheduledTime.hashCode ^ overrides.hashCode;
  }
}

class OverrideReminder {
  int rid; // reminder id
  ReminderMethod method;
  int minutes;

  OverrideReminder({
    required this.rid,
    required this.method,
    required this.minutes,
  });

  OverrideReminder copyWith({
    int? rid,
    ReminderMethod? method,
    int? minutes,
  }) {
    return OverrideReminder(
      rid: rid ?? this.rid,
      method: method ?? this.method,
      minutes: minutes ?? this.minutes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rid': rid,
      'method': method.name,
      'minutes': minutes,
    };
  }

  factory OverrideReminder.fromMap(Map<String, dynamic> map) {
    return OverrideReminder(
      rid: map['rid'] as int,
      method: ReminderMethod.values.firstWhere((e) => e.name == map['method'] as String),
      minutes: map['minutes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OverrideReminder.fromJson(String source) =>
      OverrideReminder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OverrideReminder(rid: $rid, method: $method, minutes: $minutes)';

  @override
  bool operator ==(covariant OverrideReminder other) {
    if (identical(this, other)) return true;

    return other.rid == rid && other.method == method && other.minutes == minutes;
  }

  @override
  int get hashCode => rid.hashCode ^ method.hashCode ^ minutes.hashCode;
}
