import 'package:birthday_planer/pages/Friends/friend_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:intl/intl.dart';

class FriendListItem extends StatelessWidget {
  final Friend friend;

  FriendListItem({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
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
    );
  }
}
