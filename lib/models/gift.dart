// import 'package:birthday_planer/models/friend.dart';
import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: flutter pub run build_runner build
part 'gift.g.dart';

@collection
class Gift {
  Id id = Isar.autoIncrement;
  String name;
  String? url;
  // List<Friend>? assignedFriends;

  Gift({
    required this.name,
    this.url,
    //  this.assignedFriends,
  });
}
