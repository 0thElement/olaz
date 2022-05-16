import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<QuerySnapshot> visiblePostStream(String userId, int limit) {
    return _firestore
        .collection("post")
        .where("sender", isEqualTo: userId)
        .limit(limit)
        .snapshots();
  }
}
