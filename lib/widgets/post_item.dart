import 'package:flutter/material.dart';
import 'package:olaz/screens/social/comments.dart';
import 'package:olaz/widgets/icon_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget {
  final String user;
  final String userAvatar;
  final String content;
  final String? image;
  final DateTime created;
  final DateTime edited;
  final int commentCount;
  const PostItem(this.user, this.userAvatar, this.content, this.created,
      this.edited, this.commentCount,
      {this.image, Key? key})
      : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  static const maxLines = 5;
  bool showAllContent = false;
  bool exceeded = false;

  void moveToCommentScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentScreen();
    }));
  }

  Widget userAvatar() => CircleAvatar(
        backgroundImage: NetworkImage(widget.userAvatar),
        maxRadius: 20,
      );

  Widget postInformation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.user,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            timeago.format(widget.created, locale: "en_short"),
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
        ],
      );

  Widget content() => LayoutBuilder(builder: (context, size) {
        TextPainter tp = TextPainter(
            maxLines: maxLines,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            text: TextSpan(text: widget.content));

        tp.layout(maxWidth: size.maxWidth);
        exceeded = tp.didExceedMaxLines;

        Widget content = (exceeded && !showAllContent)
            ? ShaderMask(
                child: Text(widget.content, maxLines: maxLines),
                shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent])
                    .createShader(
                        Rect.fromLTWH(0, bounds.height - 20, bounds.width, 20)))
            : Text(widget.content);
        if (exceeded) {
          content = Column(
            children: [content, toggleCollapseButton()],
          );
        }
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
            child: iconText(
                "${widget.commentCount} comment${widget.commentCount > 1 ? "s" : ""}",
                Icons.comment_rounded,
                TextStyle(color: Colors.grey[700]),
                Colors.grey[700]!)),
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
              userAvatar(),
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
          showCommentButton()
        ],
      ),
    );
  }
}
