import 'package:flutter/material.dart';
import 'package:birthday_planer/pages/calendar_page.dart';
import 'package:birthday_planer/pages/friends_list_page.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
      body: <Widget>[
        FriendsListPage(),
        CalendarPage(),
      ][currentPageIndex],
    );
  }
}
