import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/models/todo_model.dart';
import 'package:todolist/providers/calendar_state_notifier.dart';
import 'package:todolist/providers/todo_service_provider.dart';
import 'package:todolist/utils/constants.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:todolist/utils/theme/app_text_style.dart';
import 'package:todolist/utils/utils.dart';
import 'package:todolist/views/widgets/commons_widget/todo_card_widget.dart';

DateTime getSelectedDay(DateTime? selectedDay) => selectedDay ?? DateTime.now();

String formatSelectedDate(DateTime selectedDate) =>
    DateFormat(kDateFormat).format(selectedDate);

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_scrollController.position.haveDimensions) {
      return;
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isCollapsed) {
        setState(() {
          _calendarFormat = CalendarFormat.week;
          _isCollapsed = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isCollapsed) {
        setState(() {
          _calendarFormat = CalendarFormat.month;
          _isCollapsed = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    ref.read(calendarStateProvider.notifier).updateSelectedDay(selectedDay);
    ref.read(calendarStateProvider.notifier).updateFocusedDay(focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    final CalendarState calendarState = ref.watch(calendarStateProvider);
    final DateTime selectedDate = getSelectedDay(calendarState.selectedDay);
    final AsyncValue<List<TodoModel>> todoData = ref.watch(fetchStreamProvider);
    final List<TodoModel> filteredTodos = todoData.when(
      data: (todos) => filterTodosByDate(todos, selectedDate),
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          AppText.calendarTitle,
          style: AppTextStyle.header,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: (_calendarFormat == CalendarFormat.month)
                    ? 300
                    : 150,
                child: SingleChildScrollView(
                child:TableCalendar(
                  locale: "en_US",
                  rowHeight:
                  36,

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  focusedDay: calendarState.focusedDay ?? DateTime.now(),
                  firstDay: DateTime(kFirstDateYear),
                  lastDay: DateTime(kLastDateYear),
                  onDaySelected: _onDaySelected,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, _) => Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    todayBuilder: (context, date, _) => Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                ),
              ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.only(left: 10, right: 10),
              itemCount: filteredTodos.isEmpty ? 1 : filteredTodos.length,
              itemBuilder: (context, index) {
                if (filteredTodos.isEmpty) {
                  return const SizedBox(
                    child: Center(
                      child: Text(
                        "No task for today",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final TodoModel todoItem = filteredTodos[index];
                return Dismissible(
                  key: Key(todoItem.docID),
                  onDismissed: (direction) async {
                    await ref
                        .read(todoRepositoryProvider)
                        .deleteTask(todoItem.docID);
                  },
                  background: const ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: Icon(CupertinoIcons.trash),
                    ),
                  ),
                  child: TodoCardWidget(todoItem: todoItem),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
