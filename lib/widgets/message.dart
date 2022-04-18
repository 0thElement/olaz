import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final bool wasSentBySelf;
  final String message;
  final bool isTopOfChain;
  final bool isBottomOfChain;
  const Message(
      this.message, this.wasSentBySelf, this.isTopOfChain, this.isBottomOfChain,
      {Key? key})
      : super(key: key);

  static const Radius borderRadius = Radius.circular(20);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: isTopOfChain ? 10 : 2,
        bottom: isBottomOfChain ? 10 : 2,
      ),
      child: Align(
        alignment: wasSentBySelf ? Alignment.topRight : Alignment.topLeft,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              borderRadius: bubbleBorder(),
              color: backgroundColor(),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              message,
              style: textStyle(),
            )),
      ),
    );
  }
}
