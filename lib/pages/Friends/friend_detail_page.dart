import 'package:birthday_planer/models/gift.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/pages/Friends/friend_select_gift.dart';

class FriendDetailPage extends StatefulWidget {
  final Friend friend;

  FriendDetailPage({required this.friend});

  @override
  State<FriendDetailPage> createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  late TextEditingController _friendNameController;
  late TextEditingController _friendDateController;
  List<Gift> assignedGifts = [];

  @override
  void initState() {
    super.initState();
    _friendNameController = TextEditingController(text: widget.friend.name);
    _friendDateController = TextEditingController(
      text: widget.friend.birthday.toLocal().toIso8601String().split('T')[0],
    );
    initAssignedGifts();
  }

  @override
  void dispose() {
    _friendNameController.dispose();
    _friendDateController.dispose();
    super.dispose();
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

  void removeGift(Gift gift) {
    setState(() {
      assignedGifts.remove(gift);
    });
  }

  void initAssignedGifts() async {
    final database = context.read<Database>();
    if (widget.friend.assignedGiftIds.isNotEmpty) {
      List<Gift> giftsToBeAssigned = [];
      for (final giftid in widget.friend.assignedGiftIds) {
        final Gift? gift = await database.getGiftById(giftid);
        if (gift != null) {
          giftsToBeAssigned.add(gift);
        }
      }
      setState(() {
        assignedGifts = giftsToBeAssigned;
      });
    }
  }

  void _updateFriend() async {
    DateTime updatedBirthday = DateTime.parse(_friendDateController.text);

    widget.friend.name = _friendNameController.text;
    widget.friend.birthday = updatedBirthday;
    widget.friend.assignedGiftIds = assignedGifts.map((gift) => gift.id).toList();

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
    Navigator.pop(context);
  }

  void _deleteFriend() async {
    Friend friend = widget.friend;
    final bool isFriendDeleted = await context.read<Database>().deleteFriend(friend.id);

    if (!mounted) return;

    if (isFriendDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${friend.name} deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${friend.name} not deleted'),
          backgroundColor: Colors.grey,
        ),
      );
    }
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _friendDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('The gift idea will be deleted pertmanently, are you sure you want to delete it?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Delete'),
                        onPressed: () {
                          _deleteFriend();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
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
                          controller: _friendDateController,
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
                          Text('Select Gifts for ${widget.friend.name}'),
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
