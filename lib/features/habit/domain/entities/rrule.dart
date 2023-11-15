// ignore: constant_identifier_names
enum FREQ { DAILY, WEEKLY, MONTHLY, YEARLY }

// Recurrence rule
class RRULE {
  factory RRULE.daily() {
    return const RRULE(freq: FREQ.DAILY);
  }
  const RRULE({
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
}

// https://developers.google.com/calendar/api/concepts/events-calendars#recurring_events