import 'package:birthday_planer/models/gift_idea.dart';
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
      [FriendSchema, GiftSchema, GiftIdeaSchema],
      directory: dir.path,
    );
  }

  // F R I E N D - C A L L S
  // F R I E N D - C A L L S
  // F R I E N D - C A L L S
  // F R I E N D - C A L L S
  // F R I E N D - C A L L S

  // list of friends
  final List<Friend> currentFriends = [];

  // C R E A T E
  Future<bool> addFriend(Friend newFriend) async {
    final Set<String> existingFriendNames = currentFriends.map((friend) => friend.name).toSet();
    if (!existingFriendNames.contains(newFriend.name)) {
      isar.writeTxnSync(() {
        isar.friends.putSync(newFriend);
      });

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
    await deleteFriend(friend.id);

    isar.writeTxnSync(() {
      isar.friends.putSync(friend);
    });
    final Friend? updatedFriend = await isar.friends.get(friend.id);
    await getAllFriends();
    return updatedFriend;
  }

  // D E L E T E
  Future<bool> deleteFriend(Id friendId) async {
    // save to db
    await isar.writeTxn(() => isar.gifts.filter().owner((owner) => owner.idEqualTo(friendId)).deleteAll());
    final isFriendDeleted = await isar.writeTxn(() => isar.friends.delete(friendId));
    // re-read from db
    await getAllFriends();
    return isFriendDeleted;
  }

  // G I F T I D E A - C A L L S
  // G I F T I D E A - C A L L S
  // G I F T I D E A - C A L L S
  // G I F T I D E A - C A L L S
  // G I F T I D E A - C A L L S

  // list of giftIdeas
  final List<GiftIdea> currentGiftIdeas = [];

  // C R E A T E
  Future<bool> addGifIdea(GiftIdea newGiftIdea) async {
    final Set<String> existingGiftIdeas = currentGiftIdeas.map((giftIdea) => giftIdea.name).toSet();
    if (!existingGiftIdeas.contains(newGiftIdea.name)) {
      isar.writeTxnSync(() {
        isar.giftIdeas.putSync(newGiftIdea);
      });
      await getAllGiftIdeas();
      return true;
    } else {
      return false;
    }
  }

  // R E A D
  Future<void> getAllGiftIdeas() async {
    List<GiftIdea> fetchedGifts = await isar.giftIdeas.where().findAll();
    currentGiftIdeas.clear();
    currentGiftIdeas.addAll(fetchedGifts);
    notifyListeners();
  }

  Future<GiftIdea?> getGiftIdeaById(int id) async {
    return await isar.giftIdeas.get(id);
  }

  // U P D A T E
  Future<GiftIdea?> updateGiftIdea(GiftIdea giftIdea) async {
    final giftDB = await isar.gifts.get(giftIdea.id);

    if (giftDB != null) {
      await isar.writeTxn(() => isar.giftIdeas.put(giftIdea));
      final updatedGift = await isar.giftIdeas.get(giftIdea.id);
      await getAllGiftIdeas();
      return updatedGift;
    }
    return null;
  }

  // D E L E T E
  Future<bool> deleteGiftIdea(Id giftIdeaId) async {
    // save to db
    await isar.writeTxn(() => isar.gifts.filter().giftIdea((giftIdea) => giftIdea.idEqualTo(giftIdeaId)).deleteAll());
    final isGiftDeleted = await isar.writeTxn(() => isar.giftIdeas.delete(giftIdeaId));
    // re-read from db
    await getAllGiftIdeas();
    return isGiftDeleted;
  }

  // G I F T - C A L L S
  // G I F T - C A L L S
  // G I F T - C A L L S
  // G I F T - C A L L S
  // G I F T - C A L L S

  // list of giftIdeas
  final List<Gift> currentGifts = [];

  // C R E A T E
  Future<void> addGift(Gift newGift) async {
    // TODO: check for dublicates
    // save to db
    isar.writeTxnSync(() {
      isar.gifts.putSync(newGift);
    });
    // re-read from db
    await getAllGifts();
  }

  // D E L E T E
  Future<bool> deleteGift(Id giftId) async {
    // save to db
    final isGiftDeleted = await isar.writeTxn(() => isar.gifts.delete(giftId));
    // re-read from db
    await getAllGifts();
    return isGiftDeleted;
  }

  Future<void> getAllGifts() async {
    List<Gift> fetchedGifts = await isar.gifts.where().findAll();
    currentGifts.clear();
    currentGifts.addAll(fetchedGifts);
    notifyListeners();
  }
}
