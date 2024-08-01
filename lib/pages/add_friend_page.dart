import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:birthday_planer/models/friend.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    final Friend friend;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add friend'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Text('Hi mUm'),
      ),
    );
  }
}
