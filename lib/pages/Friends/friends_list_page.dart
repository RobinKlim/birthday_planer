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
  void initState() {
    super.initState();
    context.read<Database>().getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = context.watch<Database>().currentFriends;
    bool isDividerAddedFirst = false;
    bool isDividerAddedSecond = false;
    bool isDividerAddedThird = false;

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
                  child: friends.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("You haven't added any friends yet."),
                              TextButton(
                                onPressed: () => print("import friends"), // TODO: implement import friends
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.import_contacts),
                                    SizedBox(width: 8),
                                    Text(
                                      'Import from Contacts',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index];
                            final birthdayDays = friend.birthday != null ? friendsService.getDaysUntilBirthday(friend.birthday!) : null;

                            if (friend.birthday == null && !isDividerAddedFirst) {
                              isDividerAddedFirst = true;
                              return buildDividerAndTile(
                                'Birthday Not Added',
                                friend,
                                context,
                              );
                            } else if (friend.birthday != null && birthdayDays != null) {
                              if (!isDividerAddedSecond && birthdayDays > 30) {
                                isDividerAddedSecond = true;
                                return buildDividerAndTile(
                                  'Birthday in more than 30 days',
                                  friend,
                                  context,
                                );
                              } else if (!isDividerAddedThird && birthdayDays <= 30 && birthdayDays != 0) {
                                isDividerAddedThird = true;
                                return buildDividerAndTile(
                                  'Birthday within the next 30 days',
                                  friend,
                                  context,
                                );
                              }
                            }
                            return FriendListItem(friend: friend);
                          },
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDividerAndTile(String message, Friend friend, BuildContext context) {
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
              message,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 60),
            FriendListItem(friend: friend),
          ],
        ),
      ],
    );
  }
}
