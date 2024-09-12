import 'package:birthday_planer/pages/gift_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/gift.dart';

class GiftListPage extends StatefulWidget {
  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  // List<String> notes = ["First Note", "Second Note", "Third Note"];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readGifts();
  }

  void readGifts() {
    context.watch<Database>().getAllGifts();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Database>();
    List<Gift> gifts = database.currentGifts;

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
                  MaterialPageRoute(builder: (context) => GiftPage()),
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
                    return Card(
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          gifts[index].name,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
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
