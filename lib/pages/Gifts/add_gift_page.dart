import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:birthday_planer/models/gift.dart';
import 'package:birthday_planer/widgets/gift_card.dart';

class AddGiftPage extends StatefulWidget {
  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  List<String> selectedFriends = [];
  List<String> friendsList = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Emma',
  ];

  TextEditingController _giftNameController = TextEditingController();
  TextEditingController _giftDescriptionController = TextEditingController();
  TextEditingController _giftUrlController = TextEditingController();
  TextEditingController _giftPriceInEurosController = TextEditingController();

  void _addGift() async {
    final String giftName = _giftNameController.text;
    final String? giftDescription = _giftDescriptionController.text.isNotEmpty ? _giftDescriptionController.text : null;
    final String? giftLink = _giftUrlController.text.isNotEmpty ? _giftUrlController.text : null;
    final String? giftPrice = _giftPriceInEurosController.text.isNotEmpty ? _giftPriceInEurosController.text : null;
    final int? giftPriceParsed = (giftPrice != null) ? int.tryParse(giftPrice) : null;

    print(giftPriceParsed.runtimeType);

    if (giftName.isNotEmpty) {
      final newGift = Gift(name: giftName, description: giftDescription, url: giftLink, priceInEuro: giftPriceParsed);
      context.read<Database>().addGift(newGift);

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
            GiftCard(
              giftNameController: _giftNameController,
              giftDescriptionController: _giftDescriptionController,
              giftLinkController: _giftUrlController,
              giftPriceInEurosController: _giftPriceInEurosController,
            ),
            SizedBox(height: 32),
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
