import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/comment_controller.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/screens/social/comments.dart';
import 'package:olaz/widgets/icon_text.dart';
import 'package:olaz/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/user.dart';
import 'files_list_view.dart';

class PostItem extends StatefulWidget {
  final Message post;
  const PostItem(this.post, {Key? key}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  static const maxLines = 5;
  bool showAllContent = false;
  bool exceeded = false;

  User sender = User.emptyUser;

  @override
  void initState() {
    getSender();
    super.initState();
  }

  Future getSender() async {
    User user = await Get.find<UserCrud>().get(widget.post.sender);
    if (mounted) {
      setState(() {
        sender = user;
      });
    }
  }

  void moveToCommentScreen() {
    Get.replace(CommentController());
    Get.to(CommentScreen(widget.post));
  }

  Widget postInformation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            timeago.format(widget.post.createdAt.toDate(), locale: "en_short"),
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
        ],
      );

  Widget content() => LayoutBuilder(builder: (context, size) {
        double leftPadding = 35;
        double width = size.maxWidth - leftPadding;
        TextPainter tp = TextPainter(
            maxLines: maxLines,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            text: TextSpan(text: widget.post.payload));

        tp.layout(maxWidth: width);
        exceeded = tp.didExceedMaxLines;

        Widget content = (exceeded && !showAllContent)
            ? ShaderMask(
                child: Text(widget.post.payload,
                    textAlign: TextAlign.left, maxLines: maxLines),
                shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent])
                    .createShader(
                        Rect.fromLTWH(0, bounds.height - 20, bounds.width, 20)))
            : Text(
                widget.post.payload,
                textAlign: TextAlign.left,
              );
        if (exceeded) {
          content = Column(
            children: [content, toggleCollapseButton()],
          );
        }
        content = Container(
          width: width,
          padding: EdgeInsets.only(left: leftPadding),
          child: content,
        );
        return content;
      });

  Widget toggleCollapseButton() => Container(
      padding: const EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showAllContent = !showAllContent;
          });
        },
        child: iconText(
            showAllContent ? "Collapse" : "Expand",
            showAllContent ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            TextStyle(color: Colors.grey[700]),
            Colors.grey[700]!),
      ));

  Widget showCommentButton() => Container(
        padding: const EdgeInsets.only(right: 15),
        alignment: Alignment.centerRight,
        child: GestureDetector(
            onTap: () {
              setState(() {
                moveToCommentScreen();
              });
            },
            child: iconText("Comments", Icons.comment_rounded,
                TextStyle(color: Colors.grey[700]), Colors.grey[700]!)),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(
                sender.id,
                20,
                interactable: true,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(child: postInformation()),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          content(),
          const SizedBox(
            height: 15,
          ),
          widget.post.files?.isNotEmpty ?? false
              ? filesView(widget.post.files!)
              : const SizedBox(),
          const SizedBox(
            height: 15,
          ),
          showCommentButton()
        ],
      ),
    );
  }
}
