import 'package:birthday_planer/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/pages/Gifts/gift_select_friends_page.dart';
import 'package:flutter/services.dart';

class GiftCard extends StatefulWidget {
  final TextEditingController _giftNameController;
  final TextEditingController? _giftDescriptionController;
  final TextEditingController? _giftLinkController;
  final TextEditingController? _giftPriceController;

  GiftCard({
    required TextEditingController giftNameController,
    TextEditingController? giftDescriptionController,
    TextEditingController? giftLinkController,
    TextEditingController? giftPriceInEurosController,
  })  : _giftNameController = giftNameController,
        _giftDescriptionController = giftDescriptionController,
        _giftLinkController = giftLinkController,
        _giftPriceController = giftPriceInEurosController;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  List<Friend> selectedFriends = [];

  void _openSelectFriendsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftSelectFriendsPage(),
      ),
    );

    if (result != null && result is List<Friend>) {
      setState(() {
        selectedFriends = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget._giftNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              controller: widget._giftDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: widget._giftLinkController,
              decoration: InputDecoration(
                labelText: 'Link',
                labelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: widget._giftPriceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Price (€)',
                labelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              children: selectedFriends.map((friend) {
                return Chip(
                  label: Text(friend.name),
                  onDeleted: () {
                    setState(() {
                      selectedFriends.remove(friend);
                    });
                  },
                );
              }).toList(),
            ),
            TextButton(
              onPressed: _openSelectFriendsPage,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
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
    );
  }
}
