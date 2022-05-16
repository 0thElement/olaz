import 'package:flutter/material.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/models/post.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/screens/chat/chat_controller.dart';
import 'screens/homepage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return MaterialApp(
      title: 'Olaz',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const HomePage(),
    );
  }
}
