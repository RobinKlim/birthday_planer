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
    final friendsService = FriendsService();
    int? birthdayAge;
    int? daysUntilBirthday;
    if (friend.birthday != null) {
      daysUntilBirthday = friendsService.getDaysUntilBirthday(friend.birthday!);
      birthdayAge = friendsService.getBirthdayAge(friend.birthday!);
    }
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
      clipBehavior: Clip.none,
      children: [
        Card(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(friend.birthday != null ? '${friend.name} (${friendsService.getCurrentAge(friend.birthday!)})' : '${friend.name} (Add Birthday)'),
            subtitle: friend.birthday != null ? Text(DateFormat.yMMMMd().format(friend.birthday!)) : Text('Birthday not added'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendDetailPage(friend: friend)),
              );
            },
          ),
        ),
        if (daysUntilBirthday != null && daysUntilBirthday <= 30)
          Positioned(
            right: 0,
            top: -6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: friend.birthday != null
                  ? Text(
                      daysUntilBirthday == 0
                          ? '${birthdayAge!}${getOrdinalSuffix(birthdayAge)} birthday is today!'
                          : '${birthdayAge!}${getOrdinalSuffix(birthdayAge)} birthday in $daysUntilBirthday days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    )
                  : Container(),
            ),
          ),
      ],
    );
  }
}
