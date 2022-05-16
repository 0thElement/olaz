import 'package:flutter/material.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/message_bubble.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({Key? key}) : super(key: key);

  final TextEditingController messageTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Comments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => MessageBubble(
                  "comment", index % 2 == 0, true, true,
                  user: null),
            ),
          ),
          MessageBar("Write a comment...", messageTec, () {})
        ],
      ),
    );
  }
}
