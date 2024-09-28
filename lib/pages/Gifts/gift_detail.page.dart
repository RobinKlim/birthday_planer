import 'package:birthday_planer/models/gift_idea.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:flutter/services.dart';
import 'package:birthday_planer/pages/Gifts/gift_select_friends_page.dart';

class GiftDetailPage extends StatefulWidget {
  final GiftIdea gift;

  GiftDetailPage({required this.gift});

  @override
  State<GiftDetailPage> createState() => _GiftDetailPageState();
}

class _GiftDetailPageState extends State<GiftDetailPage> {
  late TextEditingController _giftNameController;
  late TextEditingController? _giftDescriptionController;
  late TextEditingController? _giftUrlController;
  late TextEditingController? _giftPriceInEurosController;
  List<Friend> assignedFriends = [];

  @override
  void initState() {
    super.initState();
    _giftNameController = TextEditingController(text: widget.gift.name);
    _giftDescriptionController = TextEditingController(text: widget.gift.description);
    _giftUrlController = TextEditingController(text: widget.gift.url);
    _giftPriceInEurosController = TextEditingController(text: widget.gift.priceInEuro != null ? widget.gift.priceInEuro.toString() : '');
    // initAssignedFriends();
  }

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController?.dispose();
    _giftUrlController?.dispose();
    _giftPriceInEurosController?.dispose();
    super.dispose();
  }

  // void initAssignedFriends() async {
  //   final database = context.read<Database>();
  //   if (widget.gift.assignedFriendIds.isNotEmpty) {
  //     List<Friend> friendsToBeAssigned = [];
  //     for (final friendId in widget.gift.assignedFriendIds) {
  //       final Friend? friend = await database.getFriendById(friendId);
  //       if (friend != null) {
  //         friendsToBeAssigned.add(friend);
  //       }
  //     }
  //     setState(() {
  //       assignedFriends = friendsToBeAssigned;
  //     });
  //   }
  // }

  void _openSelectFriendsPage(BuildContext context) async {
    List<Friend> updatedFriends = [];
    updatedFriends = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftSelectFriendsPage(
          assignedFriends: assignedFriends,
        ),
      ),
    );

    if (updatedFriends.isNotEmpty) {
      setState(() {
        assignedFriends = updatedFriends;
      });
    }
  }

  void _updateGift() async {
    widget.gift.name = _giftNameController.text;
    widget.gift.description = _giftDescriptionController?.text;
    widget.gift.url = _giftUrlController?.text;
    widget.gift.priceInEuro = parseGiftPrice();
    // widget.gift.assignedFriendIds = assignedFriends.map((friend) => friend.id).toList();

    final GiftIdea? updatedGift = await context.read<Database>().updateGiftIdea(widget.gift);
    if (!mounted) return;

    if (updatedGift != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${updatedGift.name} updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.gift.name} not updated'),
          backgroundColor: Colors.grey,
        ),
      );
    }
    Navigator.pop(context);
  }

  void removeFriend(Friend friend) {
    setState(() {
      assignedFriends.remove(friend);
    });
  }

  void _deleteGift() async {
    GiftIdea gift = widget.gift;
    final bool isGiftDeleted = await context.read<Database>().deleteGiftIdea(gift.id);

    if (!mounted) return;

    if (isGiftDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${gift.name} deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${gift.name} not deleted'),
          backgroundColor: Colors.grey,
        ),
      );
    }
    Navigator.pop(context);
  }

  int? parseGiftPrice() {
    if (_giftPriceInEurosController != null) {
      int? giftPriceInEuros = int.tryParse(_giftPriceInEurosController!.text);
      if (giftPriceInEuros != null) {
        return giftPriceInEuros;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gift.name),
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
                    content: Text('The gift idea will be deleted permanently, are you sure you want to delete it?'),
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
                          _deleteGift();
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
                      controller: _giftNameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextField(
                      controller: _giftDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(fontSize: 14.0),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      controller: _giftUrlController,
                      decoration: InputDecoration(
                        labelText: 'Link',
                        labelStyle: TextStyle(fontSize: 14.0),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      controller: _giftPriceInEurosController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Price (€)',
                        labelStyle: TextStyle(fontSize: 14.0),
                        border: InputBorder.none,
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      children: assignedFriends.map((friend) {
                        return Chip(
                          label: Text(friend.name),
                          onDeleted: () {
                            removeFriend(friend);
                          },
                        );
                      }).toList(),
                    ),
                    TextButton(
                      onPressed: () => _openSelectFriendsPage(context),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateGift();
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
