import 'package:birthday_planer/models/gift.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
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

  void _addFriend() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final String friendName = _friendNameController.text;
    final DateTime? friendBirthday = _friendBirthdayDateController.text != '' ? DateFormat('yyyy-MM-dd').parse(_friendBirthdayDateController.text) : null;
    final List<Gift> friendGifts = assignedGifts;

    Friend newFriend = Friend(name: friendName, birthday: friendBirthday);
    newFriend.gifts.addAll(friendGifts);

    bool friendAdded = await context.read<Database>().addFriend(newFriend);

    if (!mounted) return;

    if (friendAdded) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Friend added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Friend allready exists!'),
          backgroundColor: Colors.grey,
        ),
      );
    }
    if (!mounted) return;
    navigator.pop(context);
  }

  void _addFriends(List<Friend> friends) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    Map<String, int> result = await context.read<Database>().addFriends(friends);
    int addedFriendsSum = result['friendsAdded'] ?? 0;
    int duplicatesCount = result['duplicatesCount'] ?? 0;

    if (!mounted) return;

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('$addedFriendsSum friends added from your contacts. $duplicatesCount dublicates detected.'),
        backgroundColor: Colors.green,
      ),
    );
    navigator.pop(context);
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
          friendGifts: assignedGifts,
        ),
      ),
    );
    setState(() {
      assignedGifts = updatedGifts;
    });
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

  Future<void> importContacts(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      await _showImportDialog(context);
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contacts could not be imported. Permission to access contacts is required.'),
          backgroundColor: Colors.grey,
        ),
      );

      print("Contacts permission denied");
    }
  }

  Future<void> _showImportDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Import Contacts'),
          content: Text('Do you want to import all contacts or only those with a birthday?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _importContactsWithBirthday();
              },
              child: Text('With Birthday Only'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _importAllContacts();
              },
              child: Text('Import All'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _importAllContacts() async {
    Iterable<Contact> importedContacts = await ContactsService.getContacts();

    List<Friend> friendsList = importedContacts.where((importedContact) => importedContact.displayName != null).map((importedContact) {
      return Friend(
        name: importedContact.displayName!,
        birthday: importedContact.birthday,
      );
    }).toList();

    _addFriends(friendsList);
  }

  Future<void> _importContactsWithBirthday() async {
    Iterable<Contact> importedContacts = await ContactsService.getContacts();

    List<Friend> friendsList =
        importedContacts.where((importedContact) => importedContact.displayName != null && importedContact.birthday != null).map((importedContact) {
      return Friend(
        name: importedContact.displayName!,
        birthday: importedContact.birthday,
      );
    }).toList();

    _addFriends(friendsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.import_contacts),
            tooltip: 'Import Contacts',
            onPressed: () {
              importContacts(context);
            },
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
                          label: Text(gift.giftIdea.value!.name), // TODO proper Null Check
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
