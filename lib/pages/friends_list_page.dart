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

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Friends'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                child: FloatingActionButton(
                  onPressed: () => print("hi"),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.primary),
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return ListItem(friend: friends[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
