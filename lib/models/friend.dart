import 'package:birthday_planer/models/gift.dart';
import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run_build_runner build
part 'friend.g.dart';

@collection
class Friend {
  Id id = Isar.autoIncrement;
  String name;
  // DateTime birthday;
  // Gift? gift;

  Friend({
    required this.name,
    // required this.birthday,
    //  this.gift,
  });
}
