// ignore_for_file: constant_identifier_names

enum FREQ { DAILY, WEEKLY, MONTHLY, YEARLY }

// Recurrence rule
class RRULE {
  factory RRULE.daily() {
    return const RRULE(freq: FREQ.DAILY);
  }
  const RRULE({
    this.interval = 1,
    required this.freq,
  });

  final int? interval;
  final FREQ freq;

  static List<String> get list => <String>[
        FREQ.DAILY.name,
        FREQ.WEEKLY.name,
        FREQ.MONTHLY.name,
        FREQ.YEARLY.name,
      ];

  @override
  String toString() {
    return 'RRULE:FREQ=${freq.name};INTERVAL=$interval';
  }
}
