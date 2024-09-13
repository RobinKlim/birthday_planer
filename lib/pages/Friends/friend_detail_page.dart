import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/friend_card.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class FriendDetailPage extends StatefulWidget {
  final Friend friend;

  FriendDetailPage({required this.friend});

  @override
  State<FriendDetailPage> createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.friend.name);
    _dateController = TextEditingController(
      text: widget.friend.birthday.toLocal().toIso8601String().split('T')[0],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _updateFriend() async {
    DateTime updatedBirthday = DateTime.parse(_dateController.text);

    widget.friend.name = _nameController.text;
    widget.friend.birthday = updatedBirthday;

    final Friend? updatedFriend = await context.read<Database>().updateFriend(widget.friend);

    if (!mounted) return;

    if (updatedFriend != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedFriend.name} updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.friend.name} not updated!'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            FriendCard(
              friendNameController: _nameController,
              friendDateController: _dateController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateFriend();
              },
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
