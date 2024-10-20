import 'package:birthday_planer/pages/Friends/friend_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/friend.dart';
import 'package:intl/intl.dart';
import 'package:birthday_planer/services/friends_service.dart';
import 'package:confetti/confetti.dart';

class FriendListItem extends StatefulWidget {
  final Friend friend;

  FriendListItem({required this.friend});

  @override
  State<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  late ConfettiController _confettiController;
  final friendsService = FriendsService();

  @override
  void initState() {
    super.initState();
    _checkBirthday();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkBirthday() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    if (widget.friend.birthday != null) {
      int daysUntilBirthday = friendsService.getDaysUntilBirthday(widget.friend.birthday!);
      if (daysUntilBirthday == 0) {
        _confettiController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = FriendsService();

    int? birthdayAge;
    int? daysUntilBirthday;
    if (widget.friend.birthday != null) {
      daysUntilBirthday = friendsService.getDaysUntilBirthday(widget.friend.birthday!);
      birthdayAge = friendsService.getBirthdayAge(widget.friend.birthday!);
    }
    String getOrdinalSuffix(int number) {
      if (number >= 11 && number <= 13) {
        return 'th';
      }
      switch (number % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    if (daysUntilBirthday == 0) {
      _confettiController.play();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title:
                Text(widget.friend.birthday != null ? '${widget.friend.name} (${friendsService.getCurrentAge(widget.friend.birthday!)})' : widget.friend.name),
            subtitle: widget.friend.birthday != null ? Text(DateFormat.yMMMMd().format(widget.friend.birthday!)) : Text('Birthday not added'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendDetailPage(friend: widget.friend)),
              );
            },
          ),
        ),
        if (daysUntilBirthday == 0)
          Positioned.fill(
            child: Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple],
              ),
            ),
          ),
        if (daysUntilBirthday != null && daysUntilBirthday <= 30)
          Positioned(
            right: 0,
            top: -6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: daysUntilBirthday == 0 ? Colors.cyan : Colors.green,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: widget.friend.birthday != null
                  ? Text(
                      daysUntilBirthday == 0
                          ? '${birthdayAge!}${getOrdinalSuffix(birthdayAge)} birthday is today! 🎉'
                          : '${birthdayAge!}${getOrdinalSuffix(birthdayAge)} birthday in $daysUntilBirthday days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    )
                  : Container(),
            ),
          ),
      ],
    );
  }
}
