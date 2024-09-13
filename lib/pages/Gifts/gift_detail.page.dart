import 'package:birthday_planer/models/gift.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/gift_card.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/database.dart';

class GiftDetailPage extends StatefulWidget {
  final Gift gift;

  GiftDetailPage({required this.gift});

  @override
  State<GiftDetailPage> createState() => _GiftDetailPageState();
}

class _GiftDetailPageState extends State<GiftDetailPage> {
  late TextEditingController _giftNameController;
  late TextEditingController? _giftDescriptionController;
  late TextEditingController? _giftUrlController;
  late TextEditingController? _giftPriceInEurosController;

  @override
  void initState() {
    super.initState();
    _giftNameController = TextEditingController(text: widget.gift.name);
    _giftDescriptionController = TextEditingController(text: widget.gift.description);
    _giftUrlController = TextEditingController(text: widget.gift.url);
    _giftPriceInEurosController = TextEditingController(text: widget.gift.priceInEuro.toString());
  }

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController?.dispose();
    _giftUrlController?.dispose();
    _giftPriceInEurosController?.dispose();
    super.dispose();
  }

  void _updateGift() async {
    widget.gift.name = _giftNameController.text;
    widget.gift.description = _giftDescriptionController?.text;
    widget.gift.url = _giftUrlController?.text;
    widget.gift.priceInEuro = parseGiftPrice();
    final Gift? updatedGift = await context.read<Database>().updateGift(widget.gift);

    if (!mounted) return;

    if (updatedGift != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedGift.name} updated successfully!'),
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
  }

  int? parseGiftPrice() {
    // TODO: offer globally
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
