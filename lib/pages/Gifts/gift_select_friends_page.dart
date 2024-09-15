import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/selected_friends.dart';

class GiftSelectFriendsPage extends StatefulWidget {
  @override
  State<GiftSelectFriendsPage> createState() => _GiftSelectFriendsPageState();
}

class _GiftSelectFriendsPageState extends State<GiftSelectFriendsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<Database>().getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = context.watch<Database>().currentFriends;
    final selectedFriendsModel = context.watch<SelectedFriendsModel>();
    Set<int> selectedFriendIds = selectedFriendsModel.selectedFriends.map((friend) => friend.id).toSet();

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
              children: selectedFriendsModel.selectedFriends.map((friend) {
                return Chip(
                  label: Text(friend.name),
                  onDeleted: () {
                    setState(() {
                      selectedFriendsModel.removeFriend(friend);
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
                        selectedFriendsModel.addFriend(friend);
                      } else {
                        selectedFriendsModel.removeFriend(friend);
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
          Navigator.pop(context, selectedFriendsModel.selectedFriends);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
