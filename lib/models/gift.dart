// import 'package:birthday_planer/models/friend.dart';
import 'dart:ffi';

import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: flutter pub run build_runner build
part 'gift.g.dart';

@collection
class Gift {
  Id id = Isar.autoIncrement;
  String name;
  String? url;
  String? description;
  int? priceInEuro;
  // List<Friend>? assignedFriends;

  Gift({
    required this.name,
    this.description,
    this.url,
    this.priceInEuro,
    //  this.assignedFriends,
  });
}
