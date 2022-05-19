import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/add_friend_controller.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/screens/chat/add_friend.dart';
import 'package:olaz/widgets/contact_item.dart';
import 'package:olaz/widgets/popup_item.dart';

class ContactScreen extends GetView<ChatController> {
  const ContactScreen({Key? key}) : super(key: key);

  List<PopupMenuItem> addPopupMenuButtonItems() {
    return [
      createPopupItem('Add a friend', 'friend', Icons.person_add_alt_rounded),
      createPopupItem('Create a group', 'group', Icons.group_add),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) controller.fetchMessages();
    return Scaffold(
        appBar: AppBar(
          title: const TextField(
            cursorColor: Colors.white70,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                border: InputBorder.none,
                hintText: 'Search for contact',
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 'friend':
                      Get.lazyPut(() => AddFriendController());
                      Get.to(() => AddFriendScreen());
                  }
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white70,
                ),
                itemBuilder: (context) {
                  return addPopupMenuButtonItems();
                })
          ],
        ),
        body: controller.obx(
          (state) => ListView.builder(
              itemCount: state?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: ((context, index) => Obx(() {
                    Room room = state![index];
                    Message? latestMessage;
                    if (controller.messages[room.id] != null &&
                        controller.messages[room.id]!.isNotEmpty) {
                      latestMessage = controller.messages[room.id]!.last;
                    }
                    return ContactItem(room, latestMessage, 0);
                  }))),
          onEmpty: const Center(
            child: Text("No contacts found. Press + to add a contact."),
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
        ));
  }
}
