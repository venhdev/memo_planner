enum FREQ { daily, weekly, monthly, yearly }

// Recurrence rule
class RRule {
  factory RRule.daily() {
    return const RRule(freq: FREQ.daily, interval: 1);
  }
  factory RRule.dailyUntil({required String until}) {
    return RRule(freq: FREQ.daily, interval: 1, until: until);
  }
  factory RRule.weekly({required List<bool> weekdays}) {
    if (weekdays.every((day) => day == true)) return RRule.daily();
    String? byDay = RRule.getWeekDayString(weekdays);
    return RRule(freq: FREQ.weekly, byDay: byDay);
  }
  factory RRule.weeklyUntil({required List<bool> weekdays, required String until}) {
    if (weekdays.every((day) => day == true)) return RRule.dailyUntil(until: until);
    String? byDay = RRule.getWeekDayString(weekdays);
    return RRule(freq: FREQ.weekly, until: until, byDay: byDay);
  }

  // from String -- iCalendar/RFC 5545-compliant String
  factory RRule.fromString(String rruleString) {
    List<String> rruleList = rruleString.split(';');
    FREQ freq = FREQ.values.firstWhere((element) => element.name == rruleList[0].split('=')[1].toLowerCase());
    int? interval;
    String? until;
    String? byDay;

    for (int i = 1; i < rruleList.length; i++) {
      List<String> rruleItem = rruleList[i].split('=');
      switch (rruleItem[0]) {
        case 'INTERVAL':
          interval = int.parse(rruleItem[1]);
          break;
        case 'UNTIL':
          until = rruleItem[1];
          break;
        case 'BYDAY':
          byDay = rruleItem[1];
          break;
      }
    }

    return RRule(
      freq: freq,
      interval: interval,
      until: until,
      byDay: byDay,
    );
  }

  const RRule({
    required this.freq,
    this.interval,
    this.until,
    this.byDay,
    this.weekdays,
  });

  final FREQ freq;
  final int? interval;
  final String? until;
  final String? byDay;
  final List<bool>? weekdays;

  static List<String> get getFREQs => <String>[
        FREQ.daily.name,
        FREQ.weekly.name,
        // FREQ.MONTHLY.name,
        // FREQ.YEARLY.name,
      ];

  @override
  String toString() {
    String freq = this.freq.name.toUpperCase();
    String interval = this.interval != null ? ';INTERVAL=${this.interval}' : ''; // default = 1
    String byDay = (this.freq == FREQ.weekly && this.byDay != null) ? ';BYDAY=${this.byDay}' : '';
    String until = this.until != null ? ';UNTIL=${this.until}' : ''; // 'pattern: yyyyMMdd'

    return 'RRULE:FREQ=$freq$interval$byDay$until';
    // return 'RRULE:FREQ=${freq.name.toUpperCase()};INTERVAL=$interval$until';
  }

  // copyWith
  RRule copyWith({
    FREQ? freq,
    int? interval,
    String? until,
    String? byDay,
  }) {
    return RRule(
      freq: freq ?? this.freq,
      interval: interval ?? this.interval,
      until: until ?? this.until,
      byDay: byDay ?? this.byDay,
    );
  }

  bool isMatchingWeekDate(DateTime date) {
    if (byDay != null) {
      List<String> byDayList = byDay!.split(',');
      for (int i = 0; i < byDayList.length; i++) {
        switch (byDayList[i]) {
          case 'MO':
            if (date.weekday == DateTime.monday) return true;
            break;
          case 'TU':
            if (date.weekday == DateTime.tuesday) return true;
            break;
          case 'WE':
            if (date.weekday == DateTime.wednesday) return true;
            break;
          case 'TH':
            if (date.weekday == DateTime.thursday) return true;
            break;
          case 'FR':
            if (date.weekday == DateTime.friday) return true;
            break;
          case 'SA':
            if (date.weekday == DateTime.saturday) return true;
            break;
          case 'SU':
            if (date.weekday == DateTime.sunday) return true;
            break;
        }
      }
    }
    return false;
  }

  // function to get Weekday String like 'BYDAY=MO,TU,FR' by a List<bool> of 7 elements
  static String getWeekDayString(List<bool> weekdays) {
    List<String> weekdayList = [];

    for (int i = 0; i < weekdays.length; i++) {
      if (weekdays[i]) {
        switch (i) {
          case 0:
            weekdayList.add('MO');
            break;
          case 1:
            weekdayList.add('TU');
            break;
          case 2:
            weekdayList.add('WE');
            break;
          case 3:
            weekdayList.add('TH');
            break;
          case 4:
            weekdayList.add('FR');
            break;
          case 5:
            weekdayList.add('SA');
            break;
          case 6:
            weekdayList.add('SU');
            break;
        }
      }
    }

    String weekdayString = weekdayList.join(',');
    return weekdayString;
  }
}

// https://developers.google.com/calendar/api/concepts/events-calendars#recurring_events

