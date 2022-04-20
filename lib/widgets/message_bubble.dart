import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String? user;
  final String? avatar;
  final bool wasSentBySelf;
  final String message;
  final bool isTopOfChain;
  final bool isBottomOfChain;
  const MessageBubble(
      this.message, this.wasSentBySelf, this.isTopOfChain, this.isBottomOfChain,
      {this.user, this.avatar, Key? key})
      : super(key: key);

  static const Radius borderRadius = Radius.circular(20);

  bool shouldRenderSender() =>
      !wasSentBySelf && user != null && avatar != null && isTopOfChain;

  Widget userAvatar() => CircleAvatar(
        backgroundImage: NetworkImage(avatar!),
        maxRadius: 20,
      );

  Widget username() => Text(
        user!,
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
    return Container(
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
                  Positioned(child: userAvatar(), left: 7, top: -20),
                  Positioned(child: username(), left: 54, top: -20),
                ]
              : [bubble()],
          clipBehavior: Clip.none,
        ));
  }
}
