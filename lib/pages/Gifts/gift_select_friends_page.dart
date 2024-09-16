import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class GiftSelectFriendsPage extends StatefulWidget {
  final List<Friend> assignedFriends;

  GiftSelectFriendsPage({required this.assignedFriends});

  @override
  State<GiftSelectFriendsPage> createState() => _GiftSelectFriendsPageState();
}

class _GiftSelectFriendsPageState extends State<GiftSelectFriendsPage> {
  late List<Friend> selectedFriends;

  @override
  void initState() {
    super.initState();
    selectedFriends = List.from(widget.assignedFriends);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<Database>().getAllFriends();
  }

  void toggleFriendSelection(Friend friend) {
    setState(() {
      if (selectedFriends.any((selectedFriend) => selectedFriend.id == friend.id)) {
        selectedFriends.removeWhere((selectedFriend) => selectedFriend.id == friend.id);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = context.read<Database>().currentFriends;

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
              children: selectedFriends.map((friend) {
                return Chip(
                  label: Text(friend.name),
                  onDeleted: () {
                    setState(() {
                      selectedFriends.remove(friend);
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
                  value: selectedFriends.any((f) => f.id == friend.id), // Check if ID is present
                  onChanged: (bool? value) {
                    toggleFriendSelection(friend);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedFriends);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
