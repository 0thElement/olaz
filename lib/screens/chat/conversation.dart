import 'package:flutter/material.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/message_bubble.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class MessageData {
  bool wasSentBySelf;
  String message;
  String user;
  MessageData(this.user, this.message, this.wasSentBySelf);
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<MessageData> messages = [
    MessageData("user1", "Message 1", true),
    MessageData(
        "user2",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        false),
    MessageData("user1", "Message 3", true),
    MessageData("user1", "Messagealdkfj 3", true),
    MessageData("user2", "Message 4", false),
    MessageData("user2", "Messageadlfkj 5", false),
    MessageData("user2", "Message 6", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        body: Column(
          children: [
            Expanded(child: messageList(context)),
            sendMessageBar(),
          ],
        ));
  }

  Widget messageList(BuildContext context) => ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        bool isBottomOfChain = index == messages.length - 1 ||
            messages[index + 1].user != messages[index].user;
        bool isTopOfChain =
            index == 0 || messages[index - 1].user != messages[index].user;

        return MessageBubble(
          messages[index].message,
          messages[index].wasSentBySelf,
          isTopOfChain,
          isBottomOfChain,
          user: "Username",
          avatar: "",
        );
      });

  Widget sendMessageBar() => MessageBar("Write message...", () {});

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
                    const CircleAvatar(
                      backgroundImage: NetworkImage(""),
                      maxRadius: 20,
                    ),
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

  Column userInformation() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Username",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  "Online",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            )
          ]);
}
