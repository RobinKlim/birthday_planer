import 'package:birthday_planer/models/friend.dart';
import 'package:birthday_planer/models/gift_idea.dart';
import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run build_runner build
part 'gift.g.dart';

@collection
class Gift {
  Id id = Isar.autoIncrement;

  bool isBought;

  final giftIdea = IsarLink<GiftIdea>();

  final owner = IsarLink<Friend>();

  Gift({this.isBought = false});
}
