import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/screens/login/login.dart';
import 'package:olaz/screens/login/login_binding.dart';
import 'screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: () => LoginPage(), binding: LoginBinding()),
        GetPage(name: "/home", page: () => HomePage()),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    );
  }
}
