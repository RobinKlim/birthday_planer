import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class GiftSelectFriendsPage extends StatefulWidget {
  @override
  State<GiftSelectFriendsPage> createState() => _GiftSelectFriendsPageState();
}

class _GiftSelectFriendsPageState extends State<GiftSelectFriendsPage> {
  Set<int> selectedFriendIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<Database>().getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Database>();
    List<Friend> friends = database.currentFriends;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Friends'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: friends.where((friend) => selectedFriendIds.contains(friend.id)).map((friend) {
                return Chip(
                  label: Text(friend.name),
                  onDeleted: () {
                    setState(() {
                      selectedFriendIds.remove(friend.id);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              children: friends.map((friend) {
                return CheckboxListTile(
                  title: Text(friend.name),
                  value: selectedFriendIds.contains(friend.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedFriendIds.add(friend.id);
                      } else {
                        selectedFriendIds.remove(friend.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final List<Friend> selectedFriends = friends.where((friend) => selectedFriendIds.contains(friend.id)).toList();
          Navigator.pop(context, selectedFriends);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
