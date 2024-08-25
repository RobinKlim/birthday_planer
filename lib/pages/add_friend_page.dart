import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:birthday_planer/widgets/friend_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  void _addFriend() async {
    final String name = _nameController.text;
    final String birthdayStr = _dateController.text;

    if (name.isNotEmpty && birthdayStr.isNotEmpty) {
      DateTime birthday = DateFormat('yyyy-MM-dd').parse(birthdayStr);

      final friend = Friend(name: name, birthday: birthday);
      context.read<Database>().addFriend(friend);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Birthday and Name are required.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            FriendCard(
              nameController: _nameController,
              dateController: _dateController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addFriend();
              },
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Friend'),
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
