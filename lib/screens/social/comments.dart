import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/comment_controller.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/message_bubble.dart';
import 'package:olaz/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends GetView<CommentController> {
  CommentScreen(this.post, {Key? key}) : super(key: key);

  final Message post;

  final TextEditingController messageTec = TextEditingController();

  void onSend() {
    String content = messageTec.text;
    if (content.isEmpty) return;
    controller.sendComment(post.id, content);
    messageTec.clear();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchMessages(post.id);
    // scrollToBottom(100);
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
            child: controller.obx(
                (state) => ListView.builder(
                    controller: controller.scrollController
                      ..addListener(() {
                        double extent = controller
                            .scrollController.position.maxScrollExtent;
                        double current =
                            controller.scrollController.position.pixels;
                        controller.currentScroll = current;
                        if (current >= extent) controller.loadMore(post.id);
                      }),
                    itemCount: state?.length ?? 0,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      DateTime durationAgo =
                          DateTime.fromMillisecondsSinceEpoch(
                              state![index].createdAt.millisecondsSinceEpoch);
                      String time =
                          timeago.format(durationAgo, locale: 'en_short');
                      return MessageBubble(state[index].payload,
                          state[index].wasSentBySelf, true, true, time,
                          userId: state[index].sender);
                    }),
                onEmpty: const Center(
                  child: Text(
                    "No comments yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                onLoading: const Center(child: CircularProgressIndicator())),
          ),
          MessageBar("Write a comment...", messageTec, onSend)
        ],
      ),
    );
  }
}
