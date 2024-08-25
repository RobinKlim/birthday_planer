import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'friend.dart';
import 'package:path_provider/path_provider.dart';

class Database extends ChangeNotifier {
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
  Future<void> addFriend(Friend newFriend) async {
    // TODO: check for dublicates
    // save to db
    await isar.writeTxn(() => isar.friends.put(newFriend));
    // re-read from db
    await getAllFriends();
  }

  // R E A D
  Future<void> getAllFriends() async {
    List<Friend> fetchedFriends = await isar.friends.where().findAll();
    currentFriends.clear();
    currentFriends.addAll(fetchedFriends);
    notifyListeners();
  }

  Future<Friend?> getFriendById(int id) async {
    return await isar.friends.get(id);
  }

  // U P D A T E
  // TODO: return updatedFriend
  Future<Friend?> updateFriend(Friend friend) async {
    final friendDB = await isar.friends.get(friend.id);

    if (friendDB != null) {
      await isar.writeTxn(() => isar.friends.put(friend));
      final updatedFriend = await isar.friends.get(friend.id);
      await getAllFriends();
      return updatedFriend;
    }
    return null;
  }

  // D E L E T E
}
