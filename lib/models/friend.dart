import 'package:birthday_planer/models/gift.dart';
import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run build_runner build
part 'friend.g.dart';

@collection
class Friend {
  Id id = Isar.autoIncrement;

  String name;

  DateTime? birthday;

  @Backlink(to: 'owner')
  var gifts = IsarLinks<Gift>();

  Friend({required this.name, this.birthday});
}
