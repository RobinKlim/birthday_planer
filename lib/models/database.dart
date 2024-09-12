import 'package:birthday_planer/models/gift.dart';
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
      [FriendSchema, GiftSchema],
      directory: dir.path,
    );
  }

  // F R I E N D - C A L L S

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

  // G I F T - C A L L S

  // list of friends
  final List<Gift> currentGifts = [];

  // C R E A T E
  Future<void> addGift(Gift newGift) async {
    // TODO: check for dublicates
    // save to db
    await isar.writeTxn(() => isar.gifts.put(newGift));
    // re-read from db
    await getAllFriends();
  }

  // R E A D
  Future<void> getAllGifts() async {
    List<Gift> fetchedGifts = await isar.gifts.where().findAll();
    currentGifts.clear();
    currentGifts.addAll(fetchedGifts);
    notifyListeners();
  }

  Future<Gift?> getGiftById(int id) async {
    return await isar.gifts.get(id);
  }

  // U P D A T E
  // TODO: return updatedFriend
  Future<Gift?> updateGift(Gift gift) async {
    final giftDB = await isar.gifts.get(gift.id);

    if (giftDB != null) {
      await isar.writeTxn(() => isar.gifts.put(gift));
      final updatedGift = await isar.gifts.get(gift.id);
      await getAllFriends();
      return updatedGift;
    }
    return null;
  }

  // D E L E T E
}
