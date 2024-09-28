import 'package:flutter/material.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/gift_idea.dart';
import 'add_gift_page.dart';
import 'package:birthday_planer/widgets/gift_list_item.dart';

class GiftListPage extends StatefulWidget {
  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<Database>().getAllGiftIdeas();
  }

  @override
  Widget build(BuildContext context) {
    List<GiftIdea> gifts = context.watch<Database>().currentGiftIdeas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Giftideas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGiftPage()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    return GiftListItem(gift: gifts[index]);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Gift added');
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb),
                      SizedBox(width: 8),
                      Text('Suggest Gift Ideas'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
