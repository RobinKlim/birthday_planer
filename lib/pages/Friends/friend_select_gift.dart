import 'package:flutter/material.dart';
import 'package:birthday_planer/models/gift.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class FriendSelectGiftsPage extends StatefulWidget {
  final List<Gift> assignedGifts;

  FriendSelectGiftsPage({required this.assignedGifts});

  @override
  State<FriendSelectGiftsPage> createState() => _FriendSelectGiftsPageState();
}

class _FriendSelectGiftsPageState extends State<FriendSelectGiftsPage> {
  late List<Gift> selectedGifts;

  @override
  void initState() {
    super.initState();
    context.read<Database>().getAllGifts();
    selectedGifts = List.from(widget.assignedGifts);
  }

  void toggleGiftSelection(Gift gift) {
    setState(() {
      if (selectedGifts.any((selectedGift) => selectedGift.id == gift.id)) {
        selectedGifts.removeWhere((selectedGift) => selectedGift.id == gift.id);
      } else {
        selectedGifts.add(gift);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Gift> gifts = context.watch<Database>().currentGifts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Gifts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, selectedGifts);
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
              children: gifts.map((gift) {
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
          Navigator.pop(context, selectedGifts);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.done),
      ),
    );
  }
}
