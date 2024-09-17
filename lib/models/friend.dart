import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run build_runner build
part 'friend.g.dart';

@collection
class Friend {
  Id id = Isar.autoIncrement;
  String name;
  DateTime birthday;
  List<Id> assignedGiftIds;

  Friend({required this.name, required this.birthday, this.assignedGiftIds = const []});
}
