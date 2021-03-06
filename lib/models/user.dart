import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/utils/extensions.dart';

class User {
  String id = '';
  String name;
  List<String> friendIds = [];
  List<String> roomIds = [];
  String profilePicture;
  Timestamp? dateOfBirth;
  String phoneNumber;
  String bio;

  User(
      {this.id = '',
      required this.name,
      this.friendIds = const [],
      this.roomIds = const [],
      this.phoneNumber = '',
      this.bio = '',
      this.dateOfBirth,
      this.profilePicture = ''});

  static User fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return User(
        id: snapshot.id,
        name: snapshot.data()?["name"] ?? '',
        friendIds:
            ((snapshot.data()?["friends_id"] ?? []) as List).toListString(),
        roomIds: ((snapshot.data()?["room_ids"] ?? []) as List).toListString(),
        profilePicture: snapshot.data()?["profilePicture"] ?? '',
        dateOfBirth: snapshot.data()?["date_of_birth"],
        phoneNumber: snapshot.data()?["phone_number"] ?? '',
        bio: snapshot.data()?["bio"] ?? '');
  }

  static List<User> fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<User> list = List.empty(growable: true);
    for (var element in snapshot.docs) {
      var data = element.data();
      list.add(User(
        id: element.id,
        name: data['name'] ?? '',
        friendIds: ((data['friends_id'] ?? []) as List).toListString(),
        roomIds: ((data['room_ids'] ?? []) as List).toListString(),
        profilePicture: data['profilePicture'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        bio: data['bio'] ?? '',
        dateOfBirth: data['dateOfBirth'],
      ));
    }
    return list;
  }

  static User emptyUser = User(id: '', name: '');

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "name_searchable": name.toUpperCase().replaceAll(" ", "_"),
      "friends_id": friendIds,
      "room_ids": roomIds,
      "profilePicture": profilePicture,
      "date_of_birth": dateOfBirth,
      "phone_number": phoneNumber,
      "bio": bio
    };
  }
}

class UserCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, User> cache = {};

  Future<User> currentUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return User.emptyUser;
    } else {
      return get(currentUser.uid);
    }
  }

  String currentUserId() => FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<List<User>> getFriends(String id, {String name = ""}) async {
    Query<Map<String, dynamic>> userDoc =
        _firestore.collection("user").where('friends_id', arrayContains: id);
    if (name != "") {
      name = name.toUpperCase().replaceAll(' ', '_');
      userDoc = userDoc.orderBy('name_searchable').where('name_searchable',
          isGreaterThanOrEqualTo: name, isLessThanOrEqualTo: name + '\uf8ff');
    }

    List<User> list = User.fromQuerySnapshot(await userDoc.get());
    return list;
  }

  Future<void> addFriend(String userId, String friendId) async {
    DocumentReference userDoc = _firestore.collection("user").doc(userId);
    DocumentReference friendDoc = _firestore.collection("user").doc(friendId);
    User user = await get(userId);
    User friend = await get(friendId);

    if (!user.friendIds.contains(friendId)) user.friendIds.add(friendId);
    if (!friend.friendIds.contains(userId)) friend.friendIds.add(userId);

    String roomId = userId.compareTo(friendId) > 0
        ? "$userId - $friendId"
        : "$friendId - $userId";
    DocumentReference roomDoc = _firestore.collection("room").doc(roomId);
    Room room = Room(userIds: [userId, friendId]);

    if (!user.roomIds.contains(roomId)) user.roomIds.add(roomId);
    if (!friend.roomIds.contains(roomId)) friend.roomIds.add(roomId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(friendDoc, friend.toMap());
      transaction.update(userDoc, user.toMap());
      transaction.set(roomDoc, room.toMap());
    });
  }

  Future<void> removeFriend(String userId, String friendId) async {
    DocumentReference userDoc = _firestore.collection("user").doc(userId);
    DocumentReference friendDoc = _firestore.collection("user").doc(friendId);
    User user = await get(userId);
    User friend = await get(friendId);

    if (user.friendIds.contains(friendId)) user.friendIds.remove(friendId);
    if (friend.friendIds.contains(userId)) friend.friendIds.remove(userId);

    String roomId = userId.compareTo(friendId) > 0
        ? "$userId - $friendId"
        : "$friendId - $userId";
    DocumentReference roomDoc = _firestore.collection("room").doc(roomId);

    if (user.roomIds.contains(roomId)) user.roomIds.remove(roomId);
    if (friend.roomIds.contains(roomId)) friend.roomIds.remove(roomId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(friendDoc, friend.toMap());
      transaction.update(userDoc, user.toMap());
      transaction.delete(roomDoc);
    });
  }

  Future<User> get(String userId) async {
    DocumentReference<Map<String, dynamic>> userDoc =
        _firestore.collection("user").doc(userId);

    User user = User.fromDocumentSnapshot(await userDoc.get());
    cache[userId] = user;
    return user;
  }

  Future<List<User>> search(String name) async {
    name = name.toUpperCase().replaceAll(' ', '_');
    Query<Map<String, dynamic>> userDoc = _firestore
        .collection("user")
        .orderBy('name_searchable')
        .where('name_searchable',
            isGreaterThanOrEqualTo: name, isLessThanOrEqualTo: name + '\uf8ff');

    List<User> list = User.fromQuerySnapshot(await userDoc.get());
    // cache[user.id] = user;
    return list;
    // return null;
  }

  Future<User> getCached(String userId) async {
    //Unused for now
    if (cache.containsKey(userId)) return cache[userId]!;
    return get(userId);
  }

  Future<void> save(String userId, User user) async {
    await _firestore.collection("user").doc(userId).set(user.toMap());
  }

  Future<void> delete(String userId) async {
    await _firestore.collection("user").doc(userId).delete();
  }

  Future<bool> userExists(String userId) async {
    return (await _firestore.collection("user").doc(userId).get()).exists;
  }
}
