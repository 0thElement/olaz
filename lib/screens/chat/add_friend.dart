import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/add_friend_controller.dart';
import 'package:olaz/widgets/user_item.dart';

class AddFriendScreen extends GetView<AddFriendController> {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: controller.searchController,
            cursorColor: Colors.white70,
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                border: InputBorder.none,
                hintText: 'Search for new friends',
                hintStyle: TextStyle(color: Colors.white70)),
          ),
        ),
        body: controller.obx(
          (users) => ListView.builder(
              itemCount: users?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                var user = users![index];
                return UserSearchItem(user);
              })),
          onEmpty: const Center(
            child: Text("No user found"),
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
        ));
  }
}
