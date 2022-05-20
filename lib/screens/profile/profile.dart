import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/utils/extensions.dart';
import 'package:olaz/widgets/icon_text.dart';
import 'package:olaz/widgets/user_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.user, Key? key}) : super(key: key);

  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFriend = false;
  UserCrud userCrud = Get.find();

  @override
  void initState() {
    setState(() {
      isFriend = widget.user.friendIds.contains(userCrud.currentUserId());
    });
    super.initState();
  }

  Future toggleAddToContact() async {
    User currentUser = await userCrud.currentUser();
    if (currentUser.friendIds.contains(widget.user.id)) {
      print("remove");
      await userCrud.removeFriend(currentUser.id, widget.user.id);
      setState(() {
        isFriend = false;
      });
    } else {
      print("add");
      await userCrud.addFriend(currentUser.id, widget.user.id);
      setState(() {
        isFriend = true;
      });
    }
    Get.find<ChatController>().fetchMessages();
  }

  Widget avatar() {
    return UserAvatar(widget.user.id, 80);
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.user.name;
    String dateOfBirth =
        widget.user.dateOfBirth?.toDate().format() ?? "Not provided";
    String phoneNumber = widget.user.phoneNumber == ""
        ? "Not provided"
        : widget.user.phoneNumber;
    String bio = widget.user.bio == "" ? "Not provided" : widget.user.bio;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: Column(children: [
              avatar(),
              const SizedBox(
                height: 20,
              ),
              Text(
                username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                onPressed: toggleAddToContact,
                style: ElevatedButton.styleFrom(
                    primary: isFriend ? Colors.grey : Colors.lightBlue),
                child: iconText(
                    isFriend ? "Remove from contact" : "Add to contact",
                    Icons.person_add,
                    const TextStyle(color: Colors.white),
                    Colors.white)),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: iconText(dateOfBirth, Icons.calendar_today,
                    TextStyle(color: Colors.grey[700]), Colors.grey[700]!,
                    align: TextAlign.center),
              ),
              Expanded(
                child: iconText(phoneNumber, Icons.phone,
                    TextStyle(color: Colors.grey[700]), Colors.grey[700]!,
                    align: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            bio,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ]),
      )),
    );
  }
}
