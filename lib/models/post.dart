import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'message.dart';

export 'message.dart';

class PostCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Message> get(String postId) async {
    DocumentReference<Map<String, dynamic>> postDoc =
        _firestore.collection("post").doc(postId);

    return Message.fromDocumentSnapshot(await postDoc.get());
  }

  Future<void> update(String postId, Message post) async {
    await _firestore.collection("post").doc(postId).update(post.toMap());
  }

  Future<void> delete(String postId) async {
    await _firestore.collection("post").doc(postId).delete();
  }

  Future<List<Message>> getVisiblePosts(List<String> userIds, int limit) async {
    List<Message> out = [];

    for (int i = 0; i < userIds.length; i += 10) {
      List<String> group =
          userIds.getRange(i, min(i + 10, userIds.length)).toList();
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection("post")
          .where("sender", whereIn: group)
          .limit(limit)
          .get();
      List<Message> posts =
          query.docs.map((q) => Message.fromDocumentSnapshot(q)).toList();
      out.addAll(posts);
    }

    out.sort((a, b) => -a.createdAt.compareTo(b.createdAt));
    return out;
  }

  Future<void> createPost(
      String senderId, String payload, List<String>? files) async {
    DocumentReference doc = _firestore.collection("post").doc();
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
  }

  Future<String> comment(String postId, String senderId, String payload,
      List<String>? files) async {
    Get.find<MessageCrud>().sendMessage(postId, senderId, payload, files);
    DocumentReference doc =
        _firestore.collection("comment").doc(postId).collection(postId).doc();
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

  Stream<List<Message>> roomMessageStream(String roomId, int limit) {
    return _firestore
        .collection("message")
        .doc(roomId)
        .collection(roomId)
        .orderBy("created_at", descending: true)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Message.fromDocumentSnapshot(
                e as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }
}
