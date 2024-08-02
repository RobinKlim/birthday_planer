import 'package:birthday_planer/models/gift.dart';

class Friend {
  String name;
  DateTime birthday;
  bool isPresentPrepared;
  Gift? gift;

  Friend({
    required this.name,
    required this.birthday,
    this.isPresentPrepared = false,
    this.gift,
  });
}
