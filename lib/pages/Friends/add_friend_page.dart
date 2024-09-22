import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/gift.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:birthday_planer/pages/Friends/friend_select_gift.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController _friendBirthdayDateController = TextEditingController();
  TextEditingController _friendNameController = TextEditingController();
  List<Gift> assignedGifts = [];
  List<Contact>? testContacts;

  void _addFriend(Friend friend) async {
    context.read<Database>().addFriend(friend);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
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
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _friendBirthdayDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  Future<void> importContacts() async {
    PermissionStatus permission = await Permission.contacts.request();
    print("permission: $permission");
    if (permission.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        testContacts = contacts.toList();
      });

      testContacts?.forEach(
        (element) {
          print("testContacts.displayName: ${element.displayName}");
        },
      );
    } else {
      print("Contacts permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
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
                  onPressed: () {
                    importContacts();
                  },
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(Icons.import_contacts, color: Theme.of(context).colorScheme.primary),
                )),
          ),
        ],
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
                if (_friendBirthdayDateController.text != '') {
                  _addFriend(Friend(name: _friendNameController.text, birthday: DateFormat('yyyy-MM-dd').parse(_friendBirthdayDateController.text)));
                } else {
                  _addFriend(Friend(name: _friendNameController.text));
                }
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
