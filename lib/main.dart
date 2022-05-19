import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/add_friend_controller.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/controllers/login_controller.dart';
import 'package:olaz/models/post.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/screens/login/login.dart';
import 'package:olaz/screens/login/login_binding.dart';
import 'package:olaz/screens/profile/edit_profile.dart';

import 'firebase_options.dart';
import 'screens/homepage.dart';

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
  Get.put(LoginController());
  Get.put(EditProfileScreenController());
  Get.put(HomePageController());
  Get.put(AddFriendController(), tag: 'AddFriendController');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const HomePage(),
    );
  }
}
