import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/screens/chat/conversation.dart';
import 'package:olaz/widgets/user_avatar.dart';

class ContactItem extends StatelessWidget {
  final Room room;
  final String messageText;
  final String time;
  final int unreadCount;

  const ContactItem(this.room, this.messageText, this.time, this.unreadCount,
      {Key? key})
      : super(key: key);

  Widget avatar({double radius = 30}) {
    List<String> ids = room.userIds;
    String currentUser = 'TEMPORARY';
    ids.remove(currentUser);

    if (ids.length == 1) {
      return UserAvatar(ids.first, radius);
    } else if (ids.length == 2) {
      double r = radius / sqrt(2);
      return Stack(
        children: [
          Positioned(child: UserAvatar(ids.first, r), left: 0, bottom: 0),
          Positioned(child: UserAvatar(ids.last, r), top: 0, right: 0)
        ],
        clipBehavior: Clip.none,
      );
    } else {
      double r = radius / 2;
      return Stack(
        children: [
          Positioned(child: UserAvatar(ids[0], r), left: 0, top: 0),
          Positioned(child: UserAvatar(ids[1], r), right: 0, top: 0),
          Positioned(child: UserAvatar(ids[2], r), left: 0, bottom: 0),
          ids.length >= 4
              ? Positioned(child: UserAvatar(ids[3], r), left: 0, bottom: 0)
              : const SizedBox(),
        ],
        clipBehavior: Clip.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ConversationScreen(room));
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
          child: Row(
            children: [
              avatar(),
              const SizedBox(
                width: 20,
              ),
              //Name and newest message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      room.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      messageText,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              //Last send time and unread
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  (unreadCount != 0)
                      ? Container(
                          width: 16,
                          height: 16,
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
