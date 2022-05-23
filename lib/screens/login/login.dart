import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text(
      //   'Login',
      //   style: TextStyle(color: Colors.white),
      // )),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.loginFormKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
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
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: const Center(
                          child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ))),
                  onPressed: controller.login,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                ),
                OutlinedButton(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: const Center(
                        child: Text(
                          'Sign in with Google',
                        ),
                      )),
                  onPressed: controller.signInWithGoogle,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  child: const Text('Register'),
                  onPressed: controller.register,
                ),
                // ElevatedButton(
                //   child: const Text('Sign in with Facebook'),
                //   onPressed: controller.signInWithFacebook,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
