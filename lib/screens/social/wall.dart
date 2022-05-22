import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/add_friend_controller.dart';
import 'package:olaz/controllers/social_controller.dart';
import 'package:olaz/screens/chat/add_friend.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/popup_item.dart';
import 'package:olaz/widgets/post_item.dart';

class SocialWallScreen extends GetView<SocialController> {
  SocialWallScreen({Key? key}) : super(key: key);

  final TextEditingController messageTec = TextEditingController();

  List<PopupMenuItem> addPopupMenuButtonItems() {
    return [
      createPopupItem('Add a friend', 'friend', Icons.person_add_alt_rounded),
      createPopupItem('Create a group', 'group', Icons.group_add),
    ];
  }

  void onSend() {
    String content = messageTec.text;
    if (content.isEmpty) return;
    controller.createPost(content);
    messageTec.clear();
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
                hintText: 'Search for posts, users...',
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 'friend':
                      Get.lazyPut(() => AddFriendController());
                      Get.to(() => const AddFriendScreen());
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
        body: RefreshIndicator(
            onRefresh: controller.refreshPosts,
            child: Column(children: [
              Expanded(
                child: controller.obx((state) {
                  return ListView.builder(
                      controller: controller.scrollController
                        ..addListener(() {
                          double extent = controller
                              .scrollController.position.maxScrollExtent;
                          double current =
                              controller.scrollController.position.pixels;
                          controller.currentScroll = current;
                          if (current >= extent) controller.loadMorePosts();
                        }),
                      itemCount: state?.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return PostItem(state![index]);
                      }));
                },
                    onEmpty: const Center(
                      child: Text(
                        "No posts on your wall. Add more people to your contact!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    onLoading:
                        const Center(child: CircularProgressIndicator())),
              ),
              MessageBar("Share your thought...", messageTec, onSend, () {})
            ])));
  }
}
