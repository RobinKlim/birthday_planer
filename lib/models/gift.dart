import 'package:birthday_planer/models/friend.dart';

class Gift {
  final String name;
  final bool isPrepared;
  final String? url;
  final Friend? forFriend;

  Gift({
    required this.name,
    required this.isPrepared,
    this.url,
    this.forFriend,
  });
}
