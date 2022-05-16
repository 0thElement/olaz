import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/screens/chat/chat_controller.dart';

class MessageBubble extends StatelessWidget {
  final Future<User>? user;
  final bool wasSentBySelf;
  final String message;
  final bool isTopOfChain;
  final bool isBottomOfChain;
  const MessageBubble(
      this.message, this.wasSentBySelf, this.isTopOfChain, this.isBottomOfChain,
      {this.user, Key? key})
      : super(key: key);

  static const Radius borderRadius = Radius.circular(20);

  bool shouldRenderSender() => !wasSentBySelf && user != null && isTopOfChain;

  Widget userAvatar(String avatar) => CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        maxRadius: 20,
      );

  Widget username(String name) => Text(
        name,
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

  Widget bubble() => Container(
      padding: EdgeInsets.only(left: wasSentBySelf ? 0 : 54),
      alignment: wasSentBySelf ? Alignment.topRight : Alignment.topLeft,
      child: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            borderRadius: bubbleBorder(),
            color: backgroundColor(),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            message,
            style: textStyle(),
          )));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      initialData: User.emptyUser,
      future: user,
      builder: (context, snapshot) => Container(
          padding: EdgeInsets.only(
            left: 0,
            right: 14,
            top: isTopOfChain ? 10 : 2,
            bottom: isBottomOfChain ? 10 : 2,
          ),
          child: Stack(
            children: shouldRenderSender()
                ? [
                    bubble(),
                    Positioned(
                        child: userAvatar(snapshot.data?.profilePicture ?? ""),
                        left: 7,
                        top: -20),
                    Positioned(
                        child: username(snapshot.data?.name ?? ""),
                        left: 54,
                        top: -20),
                  ]
                : [bubble()],
            clipBehavior: Clip.none,
          )),
    );
  }
}
