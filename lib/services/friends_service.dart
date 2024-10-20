class FriendsService {
  static final FriendsService _instance = FriendsService._internal();

  factory FriendsService() {
    return _instance;
  }

  FriendsService._internal();

  DateTime getNextBirthday(DateTime birthday) {
    final now = DateTime.now();

    DateTime nextBirthday = DateTime(now.year, birthday.month, birthday.day);
    if (now.isAfter(nextBirthday) && !(now.day == nextBirthday.day && now.month == nextBirthday.month && now.year == nextBirthday.year)) {
      nextBirthday = DateTime(now.year + 1, birthday.month, birthday.day);
    }
    return nextBirthday;
  }

  int getDaysUntilBirthday(DateTime birthday) {
    final now = DateTime.now();
    final nextBirthday = getNextBirthday(birthday);

    DateTime from = DateTime(now.year, now.month, now.day);
    DateTime to = DateTime(nextBirthday.year, nextBirthday.month, nextBirthday.day);
    return (to.difference(from).inHours / 24).round();
  }

  int getBirthdayAge(DateTime birthday) {
    return getNextBirthday(birthday).year - birthday.year;
  }

  int getCurrentAge(DateTime birthday) {
    final DateTime today = DateTime.now();
    int age = today.year - birthday.year;

    if (today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }

    return age;
  }
}
