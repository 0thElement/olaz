import 'package:flutter/material.dart';
import 'package:olaz/screens/chat/conversation.dart';

class ContactItem extends StatefulWidget {
  final String name;
  final String messageText;
  final String image;
  final String time;
  final int unreadCount;
  const ContactItem(
      this.name, this.messageText, this.image, this.time, this.unreadCount,
      {Key? key})
      : super(key: key);

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ConversationScreen();
        }));
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
          child: Row(
            children: [
              //Avatar
              CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
                maxRadius: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              //Name and newest message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      widget.messageText,
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
                    widget.time,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  (widget.unreadCount != 0)
                      ? Container(
                          width: 16,
                          height: 16,
                          child: Text(
                            widget.unreadCount.toString(),
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
  }
}
