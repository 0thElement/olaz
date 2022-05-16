import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class User {
  String id = '';
  String firebaseId = '';
  String name;
  List<String> friendIds = [];
  List<String> roomIds = [];
  String profilePicture;

  User(
      {this.id = '',
      required this.firebaseId,
      required this.name,
      this.friendIds = const [],
      this.roomIds = const [],
      this.profilePicture = ''});

  static User fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return User(
        id: snapshot.id,
        firebaseId: snapshot.data()!["firebase_id"],
        name: snapshot.data()!["name"],
        friendIds: snapshot.data()!["friends_id"],
        roomIds: snapshot.data()!["room_ids"],
        profilePicture: snapshot.data()!["profilePicture"]);
  }

  static User emptyUser = User(id: '', name: '', firebaseId: '');

  Map<String, dynamic> toMap() {
    return {
      "firebase_id": firebaseId,
      "name": name,
      "friends_id": friendIds,
      "room_ids": roomIds,
      "profilePicture": profilePicture,
    };
  }
}

class UserCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(String userId, String friendId) async {
    DocumentReference userDoc = _firestore.collection("user").doc(userId);
    DocumentReference friendDoc = _firestore.collection("user").doc(friendId);
    User user = await get(userId);
    User friend = await get(friendId);

    if (!user.friendIds.contains(friendId)) user.friendIds.add(friendId);
    if (!friend.friendIds.contains(userId)) friend.friendIds.add(userId);

    _firestore.runTransaction((transaction) async {
      transaction.update(friendDoc, friend.toMap());
      transaction.update(userDoc, user.toMap());
    });
  }

  Future<void> removeFriend(String userId, String friendId) async {
    DocumentReference userDoc = _firestore.collection("user").doc(userId);
    DocumentReference friendDoc = _firestore.collection("user").doc(friendId);
    User user = await get(userId);
    User friend = await get(friendId);

    if (user.friendIds.contains(friendId)) user.friendIds.remove(friendId);
    if (friend.friendIds.contains(userId)) friend.friendIds.remove(userId);

    _firestore.runTransaction((transaction) async {
      transaction.update(friendDoc, friend.toMap());
      transaction.update(userDoc, user.toMap());
    });
  }

  Future<User> get(String userId) async {
    DocumentReference<Map<String, dynamic>> userDoc =
        _firestore.collection("user").doc(userId);

    return User.fromDocumentSnapshot(await userDoc.get());
  }

  Future<void> update(String userId, User user) async {
    await _firestore.collection("user").doc(userId).update(user.toMap());
  }

  Future<void> delete(String userId) async {
    await _firestore.collection("user").doc(userId).delete();
  }
}
