import 'package:isar/isar.dart';

// this file is needed to generate file
// then run: dart run build_runner build
part 'gift.g.dart';

@collection
class Gift {
  Id id = Isar.autoIncrement;
  String name;
  String? url;
  String? description;
  int? priceInEuro;
  List<Id>? assignedFriendIds;

  Gift({
    required this.name,
    this.description,
    this.url,
    this.priceInEuro,
    this.assignedFriendIds,
  });
}
