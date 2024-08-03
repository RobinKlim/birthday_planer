import 'package:birthday_planer/pages/select_friends_page.dart';
import 'package:flutter/material.dart';

class GiftPage extends StatefulWidget {
  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  List<String> selectedFriends = [];

  List<String> friendsList = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Emma',
    'Frank',
    'Grace',
    'Hannah',
    'Isaac',
    'Jack',
    'Katie',
    'Liam',
    'Mia',
    'Nathan',
    'Olivia',
    'Paul',
    'Quinn',
    'Rachel',
    'Sam',
    'Tina',
    'Uma',
    'Victor',
    'Wendy',
    'Xander',
    'Yasmin',
    'Zachary'
  ];

  void _openSelectFriendsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectFriendsPage(availableFriends: friendsList),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        selectedFriends = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giftidea'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Link',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
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
                    TextButton(
                      onPressed: _openSelectFriendsPage,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app),
                          SizedBox(width: 8),
                          Text('Select Friends'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('Friend added');
              },
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Gift'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
