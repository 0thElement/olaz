import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String> upload(String path) async {
    Reference ref = _firebaseStorage.ref(_firebaseAuth.currentUser!.uid);

    File file = File(path);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<List<String>> uploadAll(List<String> paths) async {
    List<Future<String>> tasks = [];
    for (String path in paths) {
      tasks.add(upload(path));
    }
    return Future.wait(tasks);
  }
}
