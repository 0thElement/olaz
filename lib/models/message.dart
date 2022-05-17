import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/utils/extensions.dart';

class Message {
  String id = '';
  String payload;
  List<String>? files;
  String sender;
  Timestamp createdAt;
  Timestamp? updatedAt;

  bool get wasSentBySelf => sender == Get.find<UserCrud>().currentUserId();

  Message(
      {this.id = '',
      required this.payload,
      required this.sender,
      required this.createdAt,
      this.updatedAt,
      this.files});

  Map<String, dynamic> toMap() {
    return {
      "payload": payload,
      "sender": sender,
      "files": files,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  static Message fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Message(
      id: snapshot.id,
      createdAt: snapshot.data()?["created_at"],
      updatedAt: snapshot.data()?["updated_at"],
      sender: snapshot.data()?["sender"],
      payload: snapshot.data()?["payload"],
      files: ((snapshot.data()?["files"] ?? []) as List).toListString(),
    );
  }
}

class MessageCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _roomCollectionOf(String roomId) =>
      _firestore.collection("message").doc(roomId).collection(roomId);

  Stream<List<Message>> roomMessageStream(String roomId, int limit) {
    return _roomCollectionOf(roomId)
        .orderBy("created_at", descending: false)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Message.fromDocumentSnapshot(
                e as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  Future<String> sendMessage(String roomId, String senderId, String payload,
      List<String>? files) async {
    DocumentReference doc = _roomCollectionOf(roomId).doc();
    Message message = Message(
        id: doc.id,
        payload: payload,
        sender: senderId,
        files: files,
        updatedAt: Timestamp.now(),
        createdAt: Timestamp.now());

    await _firestore.runTransaction((transaction) async {
      transaction.set(doc, message.toMap());
    });

    return doc.id;
  }

  Future<Message> get(String roomId, String messageId) async {
    DocumentReference<Map<String, dynamic>> messageDoc =
        _roomCollectionOf(roomId).doc(messageId)
            as DocumentReference<Map<String, dynamic>>;

    return Message.fromDocumentSnapshot(await messageDoc.get());
  }

  Future<void> update(String roomId, String messageId, Message message) async {
    await _roomCollectionOf(roomId).doc(messageId).update(message.toMap());
  }

  Future<void> delete(String roomId, String messageId) async {
    await _roomCollectionOf(roomId).doc(messageId).delete();
  }

  Future<void> deleteRoom(String roomId) async {
    await _firestore.collection("message").doc(roomId).delete();
  }
}
