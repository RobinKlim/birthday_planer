import 'package:birthday_planer/pages/add_friend_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/friend_list_item.dart';
import 'package:birthday_planer/models/friend.dart';

class GiftListPage extends StatefulWidget {
  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<String> notes = ["First Note", "Second Note", "Third Note"];

  Widget build(BuildContext context) {
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
                setState(() {
                  notes.add('New Note');
                });
              },
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child:
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
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
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          notes[index],
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Friend added');
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
