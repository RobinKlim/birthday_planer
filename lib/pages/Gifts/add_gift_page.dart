import 'package:birthday_planer/models/gift.dart';
import 'package:birthday_planer/pages/Gifts/gift_detail.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:birthday_planer/models/gift_idea.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:flutter/services.dart';
import 'package:birthday_planer/pages/Gifts/gift_select_friends_page.dart';

class AddGiftPage extends StatefulWidget {
  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  List<Friend> assignedFriends = [];

  TextEditingController _giftNameController = TextEditingController();
  TextEditingController _giftDescriptionController = TextEditingController();
  TextEditingController _giftUrlController = TextEditingController();
  TextEditingController _giftPriceInEurosController = TextEditingController();

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController.dispose();
    _giftUrlController.dispose();
    _giftPriceInEurosController.dispose();
    super.dispose();
  }

  void removeFriend(Friend friend) {
    setState(() {
      assignedFriends.remove(friend);
    });
  }

  void _addGift() async {
    final String giftName = _giftNameController.text;
    final String? giftDescription = _giftDescriptionController.text.isNotEmpty ? _giftDescriptionController.text : null;
    final String? giftUrl = _giftUrlController.text.isNotEmpty ? _giftUrlController.text : null;
    final String? giftPrice = _giftPriceInEurosController.text.isNotEmpty ? _giftPriceInEurosController.text : null;
    final int? giftPriceParsed = (giftPrice != null) ? int.tryParse(giftPrice) : null;

    List<Gift> gifts = [];
    for (var friend in assignedFriends) {
      Gift newGift = Gift()..owner.value = friend;
      gifts.add(newGift);
    }

    if (giftName.isNotEmpty) {
      final newGift = GiftIdea(name: giftName, description: giftDescription, url: giftUrl, priceInEuro: giftPriceParsed);
      newGift.gifts.addAll(gifts);
      context.read<Database>().addGifIdea(newGift);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gift added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name of Gift is required.')),
      );
    }
  }

  void _openSelectFriendsPage(BuildContext context) async {
    final List<Friend>? updatedFriends = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftSelectFriendsPage(
          assignedFriends: assignedFriends,
        ),
      ),
    );

    if (updatedFriends != null) {
      setState(() {
        assignedFriends = updatedFriends;
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
                _addGift();
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
