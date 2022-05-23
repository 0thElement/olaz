import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:olaz/controllers/chat_controller.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';

class AddGroupController extends GetxController with StateMixin<List<User>> {
  final searchController = TextEditingController();
  final groupNameController = TextEditingController();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  RxMap<String, User> checkedUsers = Map<String, User>.identity().obs;

  late String? uid;
  UserCrud userCrud = Get.find();
  RoomCrud roomCrud = Get.find();

  @override
  void onInit() {
    uid = auth.FirebaseAuth.instance.currentUser?.uid;
    searchController.clear();
    groupNameController.clear();
    searchController.addListener(onSearchChange);
    super.onInit();
  }

  @override
  void onReady() async {
    if (uid != null) {
      var list = await userCrud.getFriends(uid!);
      change(list, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
    super.onReady();
  }

  bool isCheck(User user) {
    if (checkedUsers[user.id] == null) {
      return false;
    }
    return true;
  }

  void onCheck(User user, bool value) {
    if (value) {
      checkedUsers[user.id] = user;
    } else {
      checkedUsers.remove(user.id);
    }
  }

  void onSearchChange() {
    _debouncer.call(() async {
      var value = searchController.value.text;
      var list = await userCrud.getFriends(uid!, name: value);
      if (list.isEmpty) {
        change(null, status: RxStatus.empty());
        return;
      }
      change(mergeListUser(list), status: RxStatus.success());
    });
  }

  void onGroupNameConfirm() async {
    var value = groupNameController.value.text;
    List<String> list = List<String>.empty(growable: true);
    checkedUsers.forEach((key, value) {
      list.add(key);
    });
    list.add(uid!);
    await roomCrud.createRoom(list, name: value);
    Get.find<ChatController>().fetchMessages();
    Get.back(closeOverlays: true);
  }

  bool shouldAddGroup() {
    return checkedUsers.isNotEmpty;
  }

  void onAddGroupClick() async {
    List<String> list = List<String>.empty(growable: true);
    checkedUsers.forEach((key, value) {
      list.add(key);
    });
    await roomCrud.createRoom(list);
  }

  List<User> mergeListUser(List<User> users) {
    List<User> ret = List<User>.empty(growable: true);
    checkedUsers.forEach((key, value) {
      ret.add(value);
    });
    for (var user in users) {
      if (checkedUsers[user.id] == null) {
        ret.add(user);
      }
    }
    return ret;
  }

  @override
  void onClose() {
    searchController.dispose();
    groupNameController.dispose();
    super.onClose();
  }

  Future<List<User>> searchFriend(String name) => userCrud.search(name);
}
