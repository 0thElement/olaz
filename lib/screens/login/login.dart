import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/screens/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              ElevatedButton(
                child: const Text('Login'),
                onPressed: controller.login,
              ),
              ElevatedButton(
                child: const Text('Sign in with Google'),
                onPressed: controller.signInWithGoogle,
              ),
              ElevatedButton(
                child: const Text('Sign in with Facebook'),
                onPressed: controller.signInWithFacebook,
              )
            ],
          ),
        ),
      ),
    );
  }
}
