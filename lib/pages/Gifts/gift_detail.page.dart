import 'package:flutter/material.dart';

class GiftDetailPage extends StatefulWidget {
  @override
  State<GiftDetailPage> createState() => _GiftDetailPageState();
}

class _GiftDetailPageState extends State<GiftDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gift"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Placeholder(),
      ),
    );
  }
}
