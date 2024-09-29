import 'package:birthday_planer/models/gift.dart';
import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run build_runner build
part 'gift_idea.g.dart';

@collection
class GiftIdea {
  Id id = Isar.autoIncrement;

  String name;

  String? description;

  String? url;

  int? priceInEuro;

  @Backlink(to: 'giftIdea')
  final gifts = IsarLinks<Gift>();

  GiftIdea({required this.name, this.description, this.priceInEuro, this.url});
}
