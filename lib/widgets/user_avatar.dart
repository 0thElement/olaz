import 'dart:math';

import 'package:flutter/material.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/user.dart';
import 'package:get/get.dart';
import 'package:olaz/screens/profile/profile.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(this.userId, this.radius,
      {this.interactable = false, Key? key})
      : super(key: key);
  final String? userId;
  final double radius;
  final bool interactable;

  Widget wrapper(Widget widget) {
    if (interactable) {
      return GestureDetector(
        onTap: () async {
          if (userId != null) {
            User user = await Get.find<UserCrud>().get(userId!);
            Get.to(ProfileScreen(user: user));
          }
        },
        child: widget,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return wrapper(
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.lightBlue[100],
        ),
      );
    }
    return FutureBuilder<User>(
      initialData: null,
      future: Get.find<ChatController>().getUser(userId!),
      builder: (context, snapshot) {
        User? user = snapshot.data;
        if (user == null || user.profilePicture == "") {
          return wrapper(
            CircleAvatar(
              backgroundColor: Colors.lightBlue[100],
              radius: radius,
            ),
          );
        }
        return wrapper(
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePicture),
            maxRadius: radius,
          ),
        );
      },
    );
  }
}

class GroupAvatar extends StatelessWidget {
  const GroupAvatar(this.userIds, this.radius, {Key? key}) : super(key: key);
  final List<String> userIds;
  final double radius;

  @override
  Widget build(BuildContext context) {
    List<String> ids = List.from(userIds);
    ids.remove(Get.find<UserCrud>().currentUserId());

    if (ids.length == 1) {
      return UserAvatar(ids.first, radius);
    } else if (ids.length == 2) {
      double r = radius / sqrt(2);
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          children: [
            Positioned(child: UserAvatar(ids.last, r), top: 0, right: 0),
            Positioned(child: UserAvatar(ids.first, r), left: 0, bottom: 0),
          ],
          clipBehavior: Clip.none,
        ),
      );
    } else {
      double r = radius / 2;
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          children: [
            Positioned(child: UserAvatar(ids[0], r), left: 0, top: 0),
            Positioned(child: UserAvatar(ids[1], r), right: 0, top: 0),
            Positioned(child: UserAvatar(ids[2], r), left: 0, bottom: 0),
            ids.length >= 4
                ? Positioned(child: UserAvatar(ids[3], r), left: 0, bottom: 0)
                : const SizedBox(),
          ],
          clipBehavior: Clip.none,
        ),
      );
    }
  }
}
