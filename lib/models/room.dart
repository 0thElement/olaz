import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:olaz/models/message.dart';
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
    };
  }

  static Room fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Room(
        id: snapshot.id,
        name: snapshot.data()!["name"],
        userIds: snapshot.data()!["user_ids"]);
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
    List<Future> tasks = [];

    for (String userId in userIds) {
      DocumentReference<Map<String, dynamic>> userDoc =
          _firestore.collection("user").doc(userId);
      userDocs.add(userDoc);

      tasks.add(
          Isolate.spawn<DocumentReference<Map<String, dynamic>>>((doc) async {
        User user = User.fromDocumentSnapshot(await doc.get());
        user.roomIds.add(roomId);
        users.add(user);
        roomName += user.name + ", ";
      }, userDoc));
    }
    await Future.wait(tasks);
    roomName = roomName.substring(0, roomName.length - 2);

    Room room = Room(id: roomId, name: roomName, userIds: userIds);

    _firestore.runTransaction((transaction) async {
      transaction.update(roomDoc, room.toMap());

      for (int i = 0; i < users.length; i++) {
        User user = users[i];
        DocumentReference userDoc = userDocs[i];

        transaction.update(userDoc, user.toMap());
      }
    }, timeout: const Duration(seconds: 60));
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

  Future<List<Room>> getRoomsOfUser(String userId) async {
    User user = await Get.find<UserCrud>().get(userId);
    List<String> roomIds = user.roomIds;

    return Future.wait(roomIds.map((id) async {
      Room room = await get(id);
      return room;
    }).toList());
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
