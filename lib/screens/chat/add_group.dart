import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:olaz/widgets/user_item_2.dart';

import '../../controllers/add_group_controller.dart';

class AddGroupScreen extends GetView<AddGroupController> {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Obx(() {
              if (controller.shouldAddGroup()) {
                return ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "New group chat",
                          confirm: ElevatedButton(
                              onPressed: controller.onGroupNameConfirm,
                              child: Text("Confirm")),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter group name or blank",
                            ),
                            controller: controller.groupNameController,
                          ));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white70,
                    ));
              }
              return Container();
            }),
          ],
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
                return UserSearchItem2.withGroupController(user, controller);
              })),
          onEmpty: const Center(
            child: Text("No user found"),
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
        ));
  }
}
