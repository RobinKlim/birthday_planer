import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/friend_card.dart';
import 'package:birthday_planer/models/friend.dart';

class FriendDetailPage extends StatelessWidget {
  final Friend friend;

  FriendDetailPage({required this.friend});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController =
        TextEditingController(text: friend.name);
    TextEditingController _dateController = TextEditingController(
        text: friend.birthday
            .toLocal()
            .toIso8601String()
            .split('T')[0]); // format to yyyy-MM-dd

    return Scaffold(
      appBar: AppBar(
        title: Text('Thomas'),
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
              onPressed: () => {print("save changes")},
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text('Save Changes'),
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
