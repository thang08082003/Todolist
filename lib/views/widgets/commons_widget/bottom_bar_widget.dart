import "package:flutter/material.dart";
import "package:todolist/views/screens/calendar_screen/calendar_screen.dart";
import 'package:todolist/views/screens/chart_screen/chart_screen.dart';
import 'package:todolist/views/screens/groups_screen/groups_screen.dart';
import "package:todolist/views/screens/home_screen/home_screen.dart";
import "package:todolist/views/screens/profile_screen/profile_screen.dart";

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const GroupsScreen(),
    const CalendarScreen(),
    const ChartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_view_month_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.stacked_line_chart_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  label: "",
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.black,
              selectedLabelStyle: const TextStyle(fontSize: 3),
              unselectedLabelStyle: const TextStyle(fontSize: 3),
            ),
          ),
        ),
      );
}
