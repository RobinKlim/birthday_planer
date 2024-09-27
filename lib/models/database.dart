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
  Future<bool> addFriend(Friend newFriend) async {
    final Set<String> existingFriendNames = currentFriends.map((friend) => friend.name).toSet();
    if (!existingFriendNames.contains(newFriend.name)) {
      // save to db
      await isar.writeTxn(() => isar.friends.put(newFriend));
      // re-read from db
      await getAllFriends();
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, int>> addFriends(List<Friend> newFriends) async {
    await getAllFriends();
    final Set<String> existingFriendNames = currentFriends.map((friend) => friend.name).toSet();
    final List<Friend> friendsCleanedForDuplicates = newFriends.where((friend) {
      return !existingFriendNames.contains(friend.name);
    }).toList();

    int duplicatesCount = newFriends.length - friendsCleanedForDuplicates.length;
    int friendsAddedCount = 0;

    await isar.writeTxn(() async {
      for (var friend in friendsCleanedForDuplicates) {
        await isar.friends.put(friend);
        friendsAddedCount++;
      }
    });

    await getAllFriends();

    return {
      'friendsAdded': friendsAddedCount,
      'duplicatesCount': duplicatesCount,
    };
  }

  // R E A D
  Future<void> getAllFriends() async {
    List<Friend> fetchedFriends = await isar.friends.where().findAll();
    currentFriends.clear();
    List<Friend> sortedFriends = sortFriendsByDaysUntilBirthday(fetchedFriends);
    currentFriends.addAll(sortedFriends);

    notifyListeners();
  }

  List<Friend> sortFriendsByDaysUntilBirthday(List<Friend> friends) {
    final now = DateTime.now();

    DateTime calculateNextBirthday(DateTime birthday) {
      DateTime nextBirthday = DateTime(now.year, birthday.month, birthday.day);
      if (now.isAfter(nextBirthday) && !(now.day == nextBirthday.day && now.month == nextBirthday.month && now.year == nextBirthday.year)) {
        nextBirthday = DateTime(now.year + 1, birthday.month, birthday.day);
      }
      return nextBirthday;
    }

    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    friends.sort((a, b) {
      final DateTime? birthdayA = a.birthday;
      final DateTime? birthdayB = b.birthday;

      if (birthdayA == null && birthdayB == null) {
        return 0; // If both birthdays are null, consider them equal
      } else if (birthdayA == null) {
        return 1; // Move `a` to the end because its birthday is null
      } else if (birthdayB == null) {
        return -1; // Move `b` to the end because its birthday is null
      } else {
        final DateTime nextBirthdayA = calculateNextBirthday(birthdayA);
        final DateTime nextBirthdayB = calculateNextBirthday(birthdayB);

        final int daysUntilBirthdayA = daysBetween(now, nextBirthdayA);
        final int daysUntilBirthdayB = daysBetween(now, nextBirthdayB);

        return daysUntilBirthdayA.compareTo(daysUntilBirthdayB);
      }
    });

    return friends;
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
  Future<bool> deleteFriend(Id friendId) async {
    // save to db
    final isFriendDeleted = await isar.writeTxn(() => isar.friends.delete(friendId));
    // re-read from db
    await getAllFriends();
    return isFriendDeleted;
  }

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
  Future<Gift?> updateGift(Gift gift) async {
    final giftDB = await isar.gifts.get(gift.id);

    if (giftDB != null) {
      await isar.writeTxn(() => isar.gifts.put(gift));
      final updatedGift = await isar.gifts.get(gift.id);
      await getAllGifts();
      return updatedGift;
    }
    return null;
  }

  // D E L E T E
  Future<bool> deleteGift(Id giftId) async {
    // save to db
    final isGiftDeleted = await isar.writeTxn(() => isar.gifts.delete(giftId));
    // re-read from db
    await getAllGifts();
    return isGiftDeleted;
  }
}
