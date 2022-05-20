import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/screens/chat/conversation.dart';
import 'package:olaz/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactItem extends StatelessWidget {
  final Room room;
  final Message? latestMessage;
  final int unreadCount;

  const ContactItem(this.room, this.latestMessage, this.unreadCount, {Key? key})
      : super(key: key);

  Widget avatar({double radius = 30}) {
    List<String> ids = room.userIds.map((s) => s.trim()).toList();
    return GroupAvatar(ids, radius);
  }

  @override
  Widget build(BuildContext context) {
    String latestPayload = "";
    String time = "";

    if (latestMessage != null) {
      DateTime durationAgo = DateTime.fromMillisecondsSinceEpoch(
          latestMessage!.createdAt.millisecondsSinceEpoch);
      latestPayload = latestMessage!.payload;
      time = timeago.format(durationAgo, locale: 'en_short');
    }

    return FutureBuilder<User>(
      initialData: null,
      future: latestMessage == null
          ? null
          : Get.find<ChatController>().getUser(latestMessage!.sender),
      builder: (context, snapshot) {
        String username = snapshot.data?.name ?? "";

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Get.to(ConversationScreen(room));
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 12, bottom: 12),
              child: Row(
                children: [
                  avatar(),
                  const SizedBox(
                    width: 20,
                  ),
                  //Name and newest latestMessage
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
                          latestMessage == null
                              ? "No messages yet"
                              : "$username: $latestPayload",
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
      },
    );
  }
}
