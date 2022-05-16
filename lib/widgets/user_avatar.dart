import 'package:flutter/material.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/user.dart';
import 'package:get/get.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(this.userId, this.radius, {Key? key}) : super(key: key);
  final String userId;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      initialData: User.emptyUser,
      future: Get.find<ChatController>().getUser(userId),
      builder: (context, snapshot) => CircleAvatar(
        backgroundImage: snapshot.data == null
            ? null // maybe replace with a default asset
            : NetworkImage(snapshot.data!.profilePicture),
        maxRadius: radius,
      ),
    );
  }
}
