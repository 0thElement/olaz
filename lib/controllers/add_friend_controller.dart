import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:olaz/models/user.dart';

class AddFriendController extends GetxController with StateMixin<List<User>> {
  final searchController = TextEditingController();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  UserCrud userCrud = Get.find();

  @override
  void onInit() {
    searchController.clear();
    searchController.addListener(onSearchChange);
    super.onInit();
  }

  @override
  void onReady() {
    change(null, status: RxStatus.empty());
    super.onReady();
  }

  void onSearchChange() {
    _debouncer.call(() async {
      var value = searchController.value.text;
      if (value == "") {
        change(null, status: RxStatus.empty());
        return;
      }
      change(null, status: RxStatus.loading());
      var list = await userCrud.search(searchController.value.text);
      if (list.isEmpty) {
        change(null, status: RxStatus.empty());
        return;
      }
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
