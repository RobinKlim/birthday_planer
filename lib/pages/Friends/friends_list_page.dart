import 'package:birthday_planer/pages/Friends/add_friend_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/friend_list_item.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

class FriendsListPage extends StatefulWidget {
  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<Database>().getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = context.watch<Database>().currentFriends;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Friends'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFriendPage()),
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                )),
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
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return FriendListItem(friend: friends[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
