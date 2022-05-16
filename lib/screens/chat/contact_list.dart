import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/screens/chat/chat_controller.dart';
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
                icon: const Icon(
                  Icons.add,
                  color: Colors.white70,
                ),
                itemBuilder: (context) {
                  return addPopupMenuButtonItems();
                })
          ],
        ),
        body: controller.obx((state) => ListView.builder(
            itemCount: state?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              Room room = state![index];
              return ContactItem(
                  room,
                  controller.messages[room.id]?.last.payload ?? "",
                  "https://cdn.discordapp.com/avatars/941261266670985248/58ae7c0c0ee9363f4f8607a4060c281c.png?size=256",
                  "1h",
                  0);
            }))));
  }
}
