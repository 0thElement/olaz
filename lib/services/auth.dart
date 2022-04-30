
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AuthService {
  final logger = Logger("Authserivce");
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();



  void register(String email, String password) async {
    try {
      var authCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
        logger.info(authCredential.user.toString());
    } on FirebaseAuthException catch (err) {
        logger.shout(err.toString());
    }

  }
}