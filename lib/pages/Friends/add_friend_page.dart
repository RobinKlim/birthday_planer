import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/gift.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:birthday_planer/pages/Friends/friend_select_gift.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController _friendBirthdayDateController = TextEditingController();
  TextEditingController _friendNameController = TextEditingController();
  List<Gift> assignedGifts = [];

  void _addFriend() async {
    final String friendName = _friendNameController.text;
    final String friendBirthdayDate = _friendBirthdayDateController.text;

    if (friendName.isNotEmpty && friendBirthdayDate.isNotEmpty) {
      DateTime birthday = DateFormat('yyyy-MM-dd').parse(friendBirthdayDate);

      final newFriend = Friend(name: friendName, birthday: birthday);
      context.read<Database>().addFriend(newFriend);

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

  void removeGift(Gift gift) {
    setState(() {
      assignedGifts.remove(gift);
    });
  }

  void _openSelectGiftsPage(BuildContext context) async {
    final List<Gift> updatedGifts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendSelectGiftsPage(
          assignedGifts: assignedGifts,
        ),
      ),
    );

    if (updatedGifts.isNotEmpty) {
      setState(() {
        assignedGifts = updatedGifts;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _friendBirthdayDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
            Card(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _friendNameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _friendBirthdayDateController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Birthday',
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      children: assignedGifts.map((gift) {
                        return Chip(
                          label: Text(gift.name),
                          onDeleted: () {
                            removeGift(gift);
                          },
                        );
                      }).toList(),
                    ),
                    TextButton(
                      onPressed: () => _openSelectGiftsPage(context),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.card_giftcard),
                          SizedBox(width: 8),
                          Text('Select Gifts'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
