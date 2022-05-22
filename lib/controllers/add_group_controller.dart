import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';

class AddGroupController extends GetxController with StateMixin<List<User>> {
  final searchController = TextEditingController();
  final groupNameController = TextEditingController();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  RxMap<String, User> checked_users = Map<String, User>.identity().obs;

  late String? uid;
  UserCrud userCrud = Get.find();
  RoomCrud roomCrud = Get.find();

  @override
  void onInit() {
    uid = FBAuth.FirebaseAuth.instance.currentUser?.uid;
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
    if (checked_users[user.id] == null) {
      return false;
    }
    return true;
  }

  void onCheck(User user, bool value) {
    if (value) {
      checked_users[user.id] = user;
    } else {
      checked_users.remove(user.id);
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
    var value = searchController.value.text;
    List<String> list = List<String>.empty(growable: true);
    checked_users.forEach((key, value) {
      list.add(key);
    });
    list.add(uid!);
    await roomCrud.createRoom(list, name: value);
  }

  bool shouldAddGroup() {
    return checked_users.isNotEmpty;
  }

  void onAddGroupClick() async {
    List<String> list = List<String>.empty(growable: true);
    checked_users.forEach((key, value) {
      list.add(key);
    });
    await roomCrud.createRoom(list);
  }

  List<User> mergeListUser(List<User> users) {
    List<User> ret = List<User>.empty(growable: true);
    checked_users.forEach((key, value) {
      ret.add(value);
    });
    for (var user in users) {
      if (checked_users[user.id] == null) {
        ret.add(user);
      }
    }
    return ret;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<List<User>> searchFriend(String name) => userCrud.search(name);
}
