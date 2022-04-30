import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:olaz/services/auth.dart';

class LoginController extends GetxController {
  final logger = Logger("LoginController");
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void login() {
    if (loginFormKey.currentContext == null) {
      return;
    }
    if (loginFormKey.currentState!.validate()) {
      checkUser(emailController.text, passwordController.text).then((auth) {
        if (auth) {
          Get.snackbar('Login', 'Login successfully');
        } else {
          Get.snackbar('Login', 'Invalid email or password');
        }
        passwordController.clear();
      });
    }
  }

  // Api Simulation
  Future<bool> checkUser(String user, String password) {
    logger.info("checkUser");
    AuthService().signInWithGoogle();
    return Future.value(true);
  }

  Future signInWithGoogle() async {
    AuthService().signInWithGoogle();
    return Future.value(true);
  }

  Future signInWithFacebook() async {
    AuthService().signInWithFacebook();
    return Future.value(true);
  }
}
