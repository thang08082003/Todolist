import "package:hooks_riverpod/hooks_riverpod.dart";

class CalendarStateNotifier extends StateNotifier<DateTime> {
  CalendarStateNotifier() : super(DateTime.now());

  DateTime get selectedDate => state;

  set selectedDate(DateTime date) {
    if (date != state) {
      state = date;
    }
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate = newDate;
  }
}

final StateNotifierProvider<CalendarStateNotifier, DateTime>
    calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, DateTime>(
  (Ref ref) => CalendarStateNotifier(),
);
