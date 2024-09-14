import 'package:flutter/material.dart';

class FriendCard extends StatefulWidget {
  final TextEditingController _friendNameController;
  final TextEditingController _frienddateController;

  FriendCard({
    required TextEditingController friendNameController,
    required TextEditingController friendDateController,
  })  : _frienddateController = friendDateController,
        _friendNameController = friendNameController;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      widget._frienddateController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: widget._friendNameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: widget._frienddateController,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
