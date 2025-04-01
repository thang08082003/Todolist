import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";
import "package:todolist/providers/date_time_provider.dart";
import "package:todolist/utils/constants.dart";

class DateTimeController {
  DateTimeController(this.ref);

  final WidgetRef ref;

  String get date => ref.watch(dateProvider);

  set date(String newDate) {
    ref.read(dateProvider.notifier).state = newDate;
  }

  String get time => ref.watch(timeProvider);

  set time(String newTime) {
    ref.read(timeProvider.notifier).state = newTime;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? getValue = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(kFirstDateYear),
      lastDate: DateTime(kLastDateYear),
    );
    if (getValue != null && context.mounted) {
      final DateFormat format = DateFormat(kDateFormat);

      date = format.format(getValue);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? getTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (getTime != null && context.mounted) {
      time = getTime.format(context);
    }
  }
}
