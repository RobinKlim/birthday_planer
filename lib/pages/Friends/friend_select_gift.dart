import 'package:birthday_planer/models/gift.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/gift_idea.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class FriendSelectGiftsPage extends StatefulWidget {
  final List<Gift> friendGifts;

  FriendSelectGiftsPage({required this.friendGifts});

  @override
  State<FriendSelectGiftsPage> createState() => _FriendSelectGiftsPageState();
}

class _FriendSelectGiftsPageState extends State<FriendSelectGiftsPage> {
  late List<GiftIdea> selectedGifts;

  @override
  void initState() {
    super.initState();
    context.read<Database>().getAllGiftIdeas();
    selectedGifts = widget.friendGifts.map((gift) => gift.giftIdea.value).cast<GiftIdea>().toList();
  }

  void toggleGiftSelection(GiftIdea gift) {
    setState(() {
      if (selectedGifts.any((selectedGift) => selectedGift.id == gift.id)) {
        selectedGifts.removeWhere((selectedGift) => selectedGift.id == gift.id);
      } else {
        selectedGifts.add(gift);
      }
    });
  }

  void _backToFriendDetailPage(BuildContext context) {
    List<Gift> gifts = [];
    for (var giftIdea in selectedGifts) {
      final Gift newGift = Gift()..giftIdea.value = giftIdea;
      gifts.add(newGift);
    }
    Navigator.pop(context, gifts);
  }

  @override
  Widget build(BuildContext context) {
    List<GiftIdea> giftIdeas = context.watch<Database>().currentGiftIdeas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Gifts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _backToFriendDetailPage(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: selectedGifts.map((gift) {
                return Chip(
                  label: Text(gift.name),
                  onDeleted: () {
                    setState(() {
                      selectedGifts.remove(gift);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              children: giftIdeas.map((gift) {
                return CheckboxListTile(
                  title: Text(gift.name),
                  value: selectedGifts.any((selectedGift) => selectedGift.id == gift.id),
                  onChanged: (bool? value) {
                    toggleGiftSelection(gift);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _backToFriendDetailPage(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
