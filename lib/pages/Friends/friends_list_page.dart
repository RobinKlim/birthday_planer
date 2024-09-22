import 'package:birthday_planer/pages/Friends/add_friend_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/friend_list_item.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/services/friends.service.dart';

class FriendsListPage extends StatefulWidget {
  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final friendsService = FriendsService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<Database>().getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = context.watch<Database>().currentFriends;
    bool isDividerAdded = false;

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
                    if (isDividerAdded || friends[index].birthday == null || friendsService.getDaysUntilBirthday(friends[index].birthday!) <= 30) {
                      return FriendListItem(friend: friends[index]);
                    } else {
                      isDividerAdded = true;
                      return Stack(
                        children: [
                          Divider(
                            height: 60,
                            indent: 32,
                            endIndent: 32,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              margin: EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Text(
                                'Birthday in more than 30 days',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 60),
                              FriendListItem(friend: friends[index]),
                            ],
                          ),
                        ],
                      );
                    }
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
