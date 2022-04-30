import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/screens/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: controller.validator,
              ),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: controller.validator,
                obscureText: true,
              ),
              RaisedButton(
                child: Text('Login'),
                onPressed: controller.login,
              )
            ],
          ),
        ),
      ),
    );
  }
}