import 'package:isar/isar.dart';
import 'friend.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  static late Isar isar;
  // I N I T I A L I Z E - D A T A B A S E

  static final Database _instance = Database._internal();
  Database._internal();

  factory Database() {
    return _instance;
  }

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [FriendSchema],
      directory: dir.path,
    );
  }

  // list of friends
  final List<Friend> currentFriends = [];

  // C R E A T E
  Future<void> addFriend(String name) async {
    // create new object
    final newFriend = Friend(name: name);
    // save to db
    await isar.writeTxn(() => isar.friends.put(newFriend));
  }

  // R E A D
  Future<List<Friend>> getAllFriends() async {
    return await isar.friends.where().findAll();
  }

  Future<Friend?> getFriendById(int id) async {
    return await isar.friends.get(id);
  }

  // U P D A T E

  // D E L E T E
}
