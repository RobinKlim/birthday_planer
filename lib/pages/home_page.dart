// import 'package:birthday_planer/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/pages/Friends/friends_list_page.dart';
import 'package:birthday_planer/pages/Gifts/gift_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     NotificationService().showNotification(title: "title", body: "era");
  //   });
  // }

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
          // NavigationDestination(
          //   icon: Icon(Icons.calendar_today),
          //   label: 'Calendar',
          // ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: 'Gifts',
          ),
        ],
      ),
      body: <Widget>[
        FriendsListPage(),
        // CalendarPage(),
        GiftListPage(),
      ][currentPageIndex],
    );
  }
}
