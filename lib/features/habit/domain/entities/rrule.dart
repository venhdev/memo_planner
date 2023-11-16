// ignore: constant_identifier_names
enum FREQ { DAILY, WEEKLY, MONTHLY, YEARLY }

// Recurrence rule
class RRule {
  factory RRule.daily() {
    return const RRule(freq: FREQ.DAILY);
  }
  factory RRule.dailyUntil({String? until}) {
    return RRule(freq: FREQ.DAILY, until: until);
  }

  const RRule({
    this.interval = 1,
    required this.freq,
    this.until,
  });

  final FREQ freq;
  final int? interval;
  final String? until;

  static List<String> get list => <String>[
        FREQ.DAILY.name,
        // FREQ.WEEKLY.name,
        // FREQ.MONTHLY.name,
        // FREQ.YEARLY.name,
      ];

  @override
  String toString() {
    String until = this.until != null ? ';UNTIL=${this.until}' : '';
    return 'RRULE:FREQ=${freq.name};INTERVAL=$interval$until';
  }

  // copyWith
  RRule copyWith({
    FREQ? freq,
    int? interval,
    String? until,
  }) {
    return RRule(
      freq: freq ?? this.freq,
      interval: interval ?? this.interval,
      until: until ?? this.until,
    );
  }
}

// https://developers.google.com/calendar/api/concepts/events-calendars#recurring_events