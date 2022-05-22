import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/controllers/add_group_controller.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/screens/profile/profile.dart';
import 'package:olaz/widgets/user_avatar.dart';

class UserSearchItem2 extends GetView {
  final User user;
  AddGroupController? groupController;
  UserSearchItem2(this.user, {Key? key}) : super(key: key);

  UserSearchItem2.withGroupController(this.user, this.groupController,
      {Key? key})
      : super(key: key);

  Widget avatar(String id) => UserAvatar(
        id,
        20,
        interactable: false,
      );

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
            onTap: () async {
              Get.to(() => ProfileScreen(user: user));
            },
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              // padding: const EdgeInsets.only(
              //     left: 20, right: 20, top: 12, bottom: 12),
              child: ListTile(
                leading: avatar(user.id),
                title: Container(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            user.bio,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                trailing: groupController != null
                    ? Obx(() {
                        return Checkbox(
                            value: groupController!.isCheck(user),
                            onChanged: (value) {
                              groupController!.onCheck(user, value!);
                            });
                      })
                    : null,
              ),
            ));
      },
    );
  }
}
