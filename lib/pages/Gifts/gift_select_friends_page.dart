import 'package:flutter/material.dart';

class GiftSelectFriendsPage extends StatefulWidget {
  final List<String> availableFriends;

  GiftSelectFriendsPage({required this.availableFriends});

  @override
  _GiftSelectFriendsPageState createState() => _GiftSelectFriendsPageState();
}

class _GiftSelectFriendsPageState extends State<GiftSelectFriendsPage> {
  List<String> selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Friends'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed selected friends list at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: selectedFriends.map((friend) {
                return Chip(
                  label: Text(friend),
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
              children: widget.availableFriends.map((friend) {
                return CheckboxListTile(
                  title: Text(friend),
                  value: selectedFriends.contains(friend),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedFriends.add(friend);
                      } else {
                        selectedFriends.remove(friend);
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
          Navigator.pop(context, selectedFriends);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
