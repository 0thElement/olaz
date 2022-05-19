import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:olaz/models/user.dart';

class AddFriendController extends GetxController with StateMixin<List<User>> {
  final searchController = TextEditingController();

  final _debouncer = Debouncer(delay: Duration(milliseconds: 500));

  UserCrud userCrud = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    searchController.clear();
    searchController.addListener(onSearchChange);
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    change(null, status: RxStatus.empty());
    super.onReady();
  }

  void onSearchChange() {
    _debouncer.call(() async {
      change(null, status: RxStatus.empty());
      var value = searchController.value.text;
      if (value == "") return;
      var list = await searchFriend(searchController.value.text);
      if (list.isEmpty) return;
      // users.addAll(list);
      change(list, status: RxStatus.success());
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<List<User>> searchFriend(String name) => userCrud.search(name);
}
