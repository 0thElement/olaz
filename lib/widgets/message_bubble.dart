import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/widgets/user_avatar.dart';

import 'files_list_view.dart';

class MessageBubble extends StatelessWidget {
  final String userId;
  final bool wasSentBySelf;
  final String message;
  final bool isTopOfChain;
  final bool isBottomOfChain;
  final String time;
  final List<String>? files;
  const MessageBubble(this.message, this.wasSentBySelf, this.isTopOfChain,
      this.isBottomOfChain, this.time,
      {required this.userId, this.files = const [], Key? key})
      : super(key: key);

  static const Radius borderRadius = Radius.circular(20);

  Widget userAvatar() => UserAvatar(
        userId,
        20,
        interactable: true,
      );

  Widget username(String name) => Text(
        "$name - $time",
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      );

  BorderRadius bubbleBorder() => wasSentBySelf
      ? BorderRadius.only(
          topLeft: borderRadius,
          topRight: Radius.zero,
          bottomLeft: borderRadius,
          bottomRight: isBottomOfChain ? borderRadius : Radius.zero,
        )
      : BorderRadius.only(
          topLeft: Radius.zero,
          topRight: borderRadius,
          bottomLeft: isBottomOfChain ? borderRadius : Radius.zero,
          bottomRight: borderRadius,
        );

  TextStyle textStyle() => TextStyle(
      fontSize: 15, color: wasSentBySelf ? Colors.white : Colors.black);

  Color backgroundColor() =>
      wasSentBySelf ? Colors.lightBlueAccent : Colors.grey[350]!;

  Widget bubble() => Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: wasSentBySelf ? 0 : 54),
              alignment: wasSentBySelf ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    borderRadius: bubbleBorder(),
                    color: backgroundColor(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: files == null || files!.isEmpty
                        ? Text(message, style: textStyle())
                        : Column(children: [
                            message == ""
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          message,
                                          style: textStyle(),
                                          textAlign: wasSentBySelf
                                              ? TextAlign.right
                                              : TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            filesView(files!)
                          ]),
                  )))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: 0,
          right: 14,
          top: isTopOfChain ? 10 : 2,
          bottom: isBottomOfChain ? 25 : 2,
        ),
        child: !wasSentBySelf && isTopOfChain
            ? FutureBuilder<User>(
                initialData: User.emptyUser,
                future: Get.find<ChatController>().getUser(userId),
                builder: (context, snapshot) => Stack(
                  children: [
                    Positioned(child: userAvatar(), left: 7, top: 0),
                    Positioned(
                        child: username(snapshot.data?.name ?? ""),
                        left: 54,
                        top: 0),
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        bubble()
                      ],
                    )
                  ],
                  clipBehavior: Clip.none,
                ),
              )
            : isTopOfChain
                ? Stack(children: [
                    Positioned(
                      child: username("You"),
                      right: 0,
                    ),
                    Column(children: [const SizedBox(height: 20), bubble()]),
                  ])
                : bubble());
  }
}
