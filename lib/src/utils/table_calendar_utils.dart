// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  const Event(this.title);

  final String title;

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<DateTime, List<Event>> _kEventSource = <DateTime, List<Event>>{
  for (int item in List<int>.generate(50, (int index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5):
        List<Event>.generate(
            item % 4 + 1, (int index) => Event('Event $item | ${index + 1}'))
}..addAll(
    <DateTime, List<Event>>{
      kToday: <Event>[
        const Event("Today's Event 1"),
        const Event("Today's Event 2"),
      ],
    },
  );

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final int dayCount = last.difference(first).inDays + 1;
  return List<DateTime>.generate(
    dayCount,
    (int index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final DateTime kToday = DateTime.now();
final DateTime kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final DateTime kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
