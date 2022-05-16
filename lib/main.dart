import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/screens/login/login.dart';
import 'package:olaz/screens/login/login_binding.dart';
import 'screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:olaz/models/post.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/controllers/chat_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(RoomCrud());
  Get.put(MessageCrud());
  Get.put(UserCrud());
  Get.put(PostCrud());
  Get.put(ChatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/login",
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      getPages: [
        GetPage(
            name: "/login",
            page: () => const LoginPage(),
            binding: LoginBinding()),
        GetPage(name: "/home", page: () => const HomePage()),
      ],
      title: 'Olaz',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    );
  }
}
