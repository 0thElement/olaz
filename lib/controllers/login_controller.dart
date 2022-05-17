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
      return 'This field must be filled';
    }
    return null;
  }

  void login() {
    if (loginFormKey.currentContext == null) {
      return;
    }
    if (loginFormKey.currentState!.validate()) {
      AuthService()
          .signInWithEmail(emailController.text, passwordController.text)
          .then((auth) {
        //TODO: Better error handling
        if (auth != null && auth.user != null) {
          Get.snackbar('Login', 'Login successfully');
          Get.offAllNamed('/home');
        } else {
          Get.snackbar('Login', 'Invalid email or password');
        }
        passwordController.clear();
      });
    }
  }

  void register() {
    AuthService()
        .registerWithEmail(emailController.text, passwordController.text)
        .then((auth) {
      //TODO: Better error handling
      if (auth != null && auth.user != null) {
        Get.snackbar('Register', 'Login successfully');
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'Could not register your account');
      }
      passwordController.clear();
    });
  }

  Future signInWithGoogle() async {
    var userCredential = await AuthService().signInWithGoogle();
    if (userCredential == null && userCredential!.user != null) {
      Get.snackbar('Login', 'Login failed');
      return Future.value(false);
    }
    Get.snackbar('Login', 'Login successfully');
    Get.offAllNamed('/home');
    return Future.value(true);
  }

  // Future signInWithFacebook() async {
  //   AuthService().signInWithFacebook();
  //   return Future.value(true);
  // }

  void signOut() {
    AuthService().signOut().then((value) => Get.offAllNamed('/login'));
  }
}
