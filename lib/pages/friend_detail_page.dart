import 'package:flutter/material.dart';

class FriendDetailPage extends StatefulWidget {
  const FriendDetailPage({super.key});

  @override
  State<FriendDetailPage> createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thomas'),
      ),
    );
  }
}
