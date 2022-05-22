import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:olaz/models/post.dart';
import 'package:olaz/models/user.dart';

class SocialController extends GetxController with StateMixin<List<Message>> {
  RxList<Message> posts = <Message>[].obs;
  PostCrud postCrud = Get.find();

  late Worker postsWorker;

  static int _postsLimit = 30;
  static const int _postsLimitIncrement = 30;

  ScrollController scrollController = ScrollController();
  double currentScroll = 0;

  @override
  void onInit() {
    postsWorker = ever(posts, onPostsChange);
    refreshPosts();
    super.onInit();
  }

  @override
  void onClose() {
    postsWorker.dispose();
    super.onClose();
  }

  Future refreshPosts() async {
    change(null, status: RxStatus.loading());
    User currentUser = await Get.find<UserCrud>().currentUser();
    List<String> ids = List.from(currentUser.friendIds);
    ids.add(currentUser.id);
    posts(await postCrud.getVisiblePosts(ids, _postsLimit));
    _postsLimit = min(_postsLimit, posts.length);
  }

  void loadMorePosts() async {
    _postsLimit += _postsLimitIncrement;
    scrollController = ScrollController(initialScrollOffset: currentScroll);
    refreshPosts();
  }

  void onPostsChange(List<Message> list) {
    if (list.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(list, status: RxStatus.success());
    }
  }

  void createPost(String message, {List<String>? files}) async {
    String currentUserId = Get.find<UserCrud>().currentUserId();
    await postCrud.createPost(currentUserId, message, files);
    refreshPosts();
  }
}
