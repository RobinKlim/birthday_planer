import 'package:birthday_planer/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/pages/Gifts/gift_select_friends_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/selected_friends.dart';

class GiftCard extends StatelessWidget {
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

  void _openSelectFriendsPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GiftSelectFriendsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Provider to get the friends from the model
    final List<Friend> assignedFriends = context.watch<SelectedFriendsModel>().selectedFriends;

    return Card(
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
              controller: _giftLinkController,
              decoration: InputDecoration(
                labelText: 'Link',
                labelStyle: TextStyle(fontSize: 14.0),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _giftPriceController,
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
                    context.read<SelectedFriendsModel>().removeFriend(friend);
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
    );
  }
}
