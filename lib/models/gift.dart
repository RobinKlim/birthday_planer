import 'package:birthday_planer/models/friend.dart';

class Gift {
  final String name;
  final bool isBought;
  final String? url;
  final Friend? forFriend;

  Gift({
    required this.name,
    required this.isBought,
    this.url,
    this.forFriend,
  });
}
