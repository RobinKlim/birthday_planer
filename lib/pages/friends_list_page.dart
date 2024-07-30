import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/list_item.dart';
import 'package:birthday_planer/models/friend.dart';

class FriendsList extends StatefulWidget {
  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final List<Friend> friends = [
      Friend(name: 'Robin', birthday: DateTime(1992, 7, 11)),
      Friend(name: 'Alex', birthday: DateTime(1985, 5, 21)),
      Friend(name: 'Ben', birthday: DateTime(1924, 12, 23)),
      Friend(name: 'Sarah', birthday: DateTime(1915, 5, 1)),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return ListItem(friend: friends[index]);
          },
        ),
      ),
    );
  }
}
