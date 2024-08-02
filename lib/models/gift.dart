import 'package:birthday_planer/models/friend.dart';

class Gift {
  String name;
  String? url;
  List<Friend>? assignedFriends;

  Gift({
    required this.name,
    this.url,
    this.assignedFriends,
  });
}
