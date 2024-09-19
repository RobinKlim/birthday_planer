import 'package:birthday_planer/models/friend.dart';

class FriendsService {
  static final FriendsService _instance = FriendsService._internal();

  factory FriendsService() {
    return _instance;
  }

  FriendsService._internal();

  DateTime getNextBirthday(Friend friend) {
    final now = DateTime.now();

    DateTime nextBirthday = DateTime(now.year, friend.birthday.month, friend.birthday.day);
    if (now.isAfter(nextBirthday) && !(now.day == nextBirthday.day && now.month == nextBirthday.month && now.year == nextBirthday.year)) {
      nextBirthday = DateTime(now.year + 1, friend.birthday.month, friend.birthday.day);
    }
    return nextBirthday;
  }

  int getDaysUntilBirthday(Friend friend) {
    final now = DateTime.now();
    final nextBirthday = getNextBirthday(friend);

    DateTime from = DateTime(now.year, now.month, now.day);
    DateTime to = DateTime(nextBirthday.year, nextBirthday.month, nextBirthday.day);
    return (to.difference(from).inHours / 24).round();
  }

  int getBirthdayAge(Friend friend) {
    return getNextBirthday(friend).year - friend.birthday.year;
  }
}
