import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/utils/extensions.dart';

import 'user.dart';

class Room {
  String id = '';
  String name;
  List<String> userIds = [];

  Room({
    this.id = '',
    required this.name,
    this.userIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "user_ids": userIds,
      "name_search": buildNameSearch(name),
    };
  }

  Map<String, bool> buildNameSearch(String roomName) {
    var roomNameSearch = List<String>.empty(growable: true);
    var names = roomName.split(',').map((e) => e.trim());
    for (var name in names) {
      var nameSearch = buildPhraseSearch(name);
      roomNameSearch.addAll(nameSearch);
    }
    var mapping = {for (var value in roomNameSearch) value: true};
    return mapping;
  }

  List<String> buildPhraseSearch(String phrase) {
    var words = phrase.split(' ').map((e) => e.trim());
    var phraseSearch = List<String>.empty(growable: true);
    var curWord = List<String>.empty(growable: true);
    for (var value in words) {
      var chars = value.split('');
      var wordSearch = List<String>.empty(growable: true);
      var cur = '';
      for (var value1 in chars) {
        cur += value1;
        wordSearch.add(cur);
      }
      curWord.add(cur);
      phraseSearch.addAll(wordSearch);
      phraseSearch.add(curWord.join('_'));
    }
    return phraseSearch;
  }

  static Room fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Room(
        id: snapshot.id,
        name: snapshot.data()?["name"],
        userIds: ((snapshot.data()?["user_ids"] ?? []) as List).toListString());
  }

  static List<Room> fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Room> list = List.empty(growable: true);
    for (var element in snapshot.docs) {
      var data = element.data();
      list.add(Room(
        id: element.id,
        name: data['name'] ?? '',
        userIds: ((data['user_ids'] ?? []) as List).toListString(),
      ));
    }
    return list;
  }
}

class RoomCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom(List<String> userIds) async {
    DocumentReference roomDoc = _firestore.collection("room").doc();
    String roomId = roomDoc.id;
    String roomName = "";

    List<User> users = [];
    List<DocumentReference> userDocs = [];

    for (String userId in userIds) {
      DocumentReference<Map<String, dynamic>> userDoc =
          _firestore.collection("user").doc(userId);

      User user = User.fromDocumentSnapshot(await userDoc.get());
      user.roomIds.add(roomId);

      userDocs.add(userDoc);
      users.add(user);
    }

    roomName = users.map((e) => e.name).join(", ");

    Room room = Room(id: roomId, name: roomName, userIds: userIds);

    await _firestore.runTransaction((transaction) async {
      // transaction.update(roomDoc, room.toMap());
      transaction.set(roomDoc, room.toMap());

      for (int i = 0; i < users.length; i++) {
        transaction.update(userDocs[i], users[i].toMap());
      }
    }, timeout: const Duration(seconds: 5));
    return roomId;
  }

  Future<void> addUserToRoom(String roomId, String userId) async {
    DocumentReference<Map<String, dynamic>> roomDoc =
        _firestore.collection("room").doc(roomId);
    Room room = Room.fromDocumentSnapshot(await roomDoc.get());

    DocumentReference<Map<String, dynamic>> userDoc =
        _firestore.collection("user").doc(userId);
    User user = User.fromDocumentSnapshot(await userDoc.get());

    if (!user.roomIds.contains(roomId)) user.roomIds.add(roomId);
    if (!room.userIds.contains(roomId)) room.userIds.add(userId);

    _firestore.runTransaction((transaction) async {
      transaction.update(roomDoc, room.toMap());
      transaction.update(userDoc, user.toMap());
    });
  }

  Future<void> removeUserFromRoom(String roomId, String userId) async {
    DocumentReference<Map<String, dynamic>> roomDoc =
        _firestore.collection("room").doc(roomId);
    Room room = Room.fromDocumentSnapshot(await roomDoc.get());

    DocumentReference<Map<String, dynamic>> userDoc =
        _firestore.collection("user").doc(userId);
    User user = User.fromDocumentSnapshot(await userDoc.get());

    if (user.roomIds.contains(roomId)) user.roomIds.remove(roomId);
    if (room.userIds.contains(roomId)) room.userIds.remove(userId);

    _firestore.runTransaction((transaction) async {
      transaction.update(roomDoc, room.toMap());
      transaction.update(userDoc, user.toMap());
    });
  }

  Future<List<Room>> getRoomsOfUser(String userId, {String query = ""}) async {
    User user = await Get.find<UserCrud>().get(userId);

    var queryBuilder = FirebaseFirestore.instance
        .collection('room')
        .where('user_ids', arrayContains: userId);
    if (query != "") {
      query = query.replaceAll(' ', '_');
      queryBuilder = queryBuilder.where('name_search.$query', isEqualTo: true);
    }

    var results = Room.fromQuerySnapshot(await queryBuilder.get());
    return results;
  }

  Future<Room> get(String roomId) async {
    DocumentReference<Map<String, dynamic>> roomDoc =
        _firestore.collection("room").doc(roomId);

    return Room.fromDocumentSnapshot(await roomDoc.get());
  }

  Future<void> update(String roomId, Room room) async {
    await _firestore.collection("room").doc(roomId).update(room.toMap());
  }

  Future<void> delete(String roomId) async {
    await _firestore.collection("room").doc(roomId).delete();
    Get.find<MessageCrud>().deleteRoom(roomId);
  }
}
