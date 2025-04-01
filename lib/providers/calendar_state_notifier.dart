import "package:hooks_riverpod/hooks_riverpod.dart";

class CalendarState {
  CalendarState({
    this.selectedDay,
    this.focusedDay,
  });

  final DateTime? selectedDay;

  final DateTime? focusedDay;

  CalendarState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) =>
      CalendarState(
        selectedDay: selectedDay ?? this.selectedDay,
        focusedDay: focusedDay ?? this.focusedDay,
      );
}

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  CalendarStateNotifier() : super(CalendarState(focusedDay: DateTime.now()));

  void updateSelectedDay(DateTime newSelectedDay) {
    state = state.copyWith(selectedDay: newSelectedDay);
  }

  void updateFocusedDay(DateTime newFocusedDay) {
    state = state.copyWith(focusedDay: newFocusedDay);
  }
}

final StateNotifierProvider<CalendarStateNotifier, CalendarState>
    calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, CalendarState>(
  (Ref ref) => CalendarStateNotifier(),
);
