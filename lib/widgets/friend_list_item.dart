import 'package:birthday_planer/pages/Friends/friend_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:intl/intl.dart';
import 'package:birthday_planer/services/friends.service.dart';

class FriendListItem extends StatelessWidget {
  final Friend friend;

  FriendListItem({required this.friend});

  @override
  Widget build(BuildContext context) {
    final friendsService = FriendsService(); // Access the singleton instance
    final int birthdayAge = friendsService.getBirthdayAge(friend);
    final int daysUntilBirthday = friendsService.getDaysUntilBirthday(friend);
    String getOrdinalSuffix(int number) {
      if (number >= 11 && number <= 13) {
        return 'th';
      }
      switch (number % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    return Stack(
      children: [
        Card(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(friend.name),
            subtitle: Text(DateFormat.yMMMMd().format(friend.birthday)),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendDetailPage(friend: friend)),
              );
            },
          ),
        ),
        if (daysUntilBirthday <= 30)
          Positioned(
            right: 0.0,
            top: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                daysUntilBirthday == 0
                    ? '$birthdayAge${getOrdinalSuffix(birthdayAge)} birthday is today!'
                    : '$birthdayAge${getOrdinalSuffix(birthdayAge)} birthday in $daysUntilBirthday days',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
