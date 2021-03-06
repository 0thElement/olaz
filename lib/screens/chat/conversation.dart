import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/message_bubble.dart';
import 'package:olaz/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationScreen extends StatelessWidget {
  ConversationScreen(this.room, {Key? key}) : super(key: key);

  final Room room;
  final ChatController controller = Get.find();
  final TextEditingController messageTec = TextEditingController();
  final FocusNode messageFocus = FocusNode();
  final ScrollController scrollController = ScrollController();

  void onSend(String content, List<String>? files) {
    if (content.isEmpty && (files == null || files.isEmpty)) return;
    controller.sendMessage(room, content, files: files);
    messageTec.clear();
  }

  Widget avatar({double radius = 30}) {
    List<String> ids = room.userIds.map((s) => s.trim()).toList();
    return GroupAvatar(ids, radius);
  }

  @override
  Widget build(BuildContext context) {
    controller.scrollController[room.id] = ScrollController();
    return Scaffold(
        appBar: customAppBar(context),
        body: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Expanded(child: messageList(context)),
              sendMessageBar(),
            ],
          ),
        ));
  }

  Widget messageList(BuildContext context) => Obx(() {
        List<Message> messages = controller.messages[room.id]!;
        controller.roomMessagesLimit[room.id] =
            min(controller.roomMessagesLimit[room.id]!, messages.length);
        return ListView.builder(
            controller: controller.scrollController[room.id]!
              ..addListener(() {
                ScrollController scr = controller.scrollController[room.id]!;
                double current = scr.position.pixels;
                double extent = scr.position.maxScrollExtent;
                controller.currentScroll[room.id] = current;
                if (current >= extent) controller.loadMoreMessages(room);
              }),
            itemCount: messages.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              bool isTopOfChain = index == messages.length - 1 ||
                  messages[index + 1].sender != messages[index].sender;
              bool isBottomOfChain = index == 0 ||
                  messages[index - 1].sender != messages[index].sender;

              DateTime durationAgo = DateTime.fromMillisecondsSinceEpoch(
                  messages[index].createdAt.millisecondsSinceEpoch);
              String time = timeago.format(durationAgo, locale: 'en_short');

              return MessageBubble(
                messages[index].payload,
                messages[index].wasSentBySelf,
                isTopOfChain,
                isBottomOfChain,
                time,
                userId: messages[index].sender,
                files: messages[index].files,
              );
            });
      });

  Widget sendMessageBar() => MessageBar("Write message...", messageTec, onSend);

  AppBar customAppBar(BuildContext context) => AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    // Return button
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white)),
                    avatar(radius: 20),
                    // User avatar, username, status
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: userInformation(),
                    ),
                    // Buttons
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        )),
                  ],
                ))),
      );

  Widget name(String name, TextStyle style) =>
      LayoutBuilder(builder: (context, size) {
        TextPainter tp = TextPainter(
            maxLines: 1,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            text: TextSpan(text: name, style: style));

        tp.layout(maxWidth: size.maxWidth);
        bool exceeded = tp.didExceedMaxLines;

        Widget content = exceeded
            ? ShaderMask(
                child: Text(
                  name,
                  maxLines: 1,
                  style: style,
                ),
                shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.white, Colors.blue])
                    .createShader(
                        Rect.fromLTWH(bounds.width - 30, 0, 30, bounds.height)))
            : Text(name, style: style);
        return content;
      });

  Column userInformation() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            name(
              room.displayName,
              const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "${room.userIds.length} members",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            )
          ]);
}
