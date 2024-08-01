import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final Friend friend;

  ListItem({required this.friend});

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
      ),
    );
  }
}
