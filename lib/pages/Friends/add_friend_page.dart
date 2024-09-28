import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/gift_idea.dart';
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
  List<GiftIdea> assignedGiftIdeas = [];

  void _addFriend(Friend friend) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    bool friendAdded = await context.read<Database>().addFriend(friend);
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

  void removeGift(GiftIdea gift) {
    setState(() {
      assignedGiftIdeas.remove(gift);
    });
  }

  void _openSelectGiftsPage(BuildContext context) async {
    final List<GiftIdea> updatedGifts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendSelectGiftsPage(
          assignedGifts: assignedGiftIdeas,
        ),
      ),
    );

    if (updatedGifts.isNotEmpty) {
      setState(() {
        assignedGiftIdeas = updatedGifts;
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

  Future<void> importContacts(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.request();
    print("permission: $permission");
    if (permission.isGranted) {
      Iterable<Contact> importedContacts = await ContactsService.getContacts();

      List<Friend> friendsList = importedContacts.where((importedContact) => importedContact.displayName != null).map((importedContact) {
        if (importedContact.birthday == null) {
          return Friend(
            name: importedContact.displayName!,
          );
        } else {
          return Friend(
            name: importedContact.displayName!,
            birthday: importedContact.birthday,
          );
        }
      }).toList();
      _addFriends(friendsList);
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contacts could not be imported. Permission to access contacts is required.'),
          backgroundColor: Colors.grey,
        ),
      );

      print("Contacts permission denied"); //TODO ask for permissions again if denied
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
                    importContacts(context);
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
                      children: assignedGiftIdeas.map((gift) {
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
