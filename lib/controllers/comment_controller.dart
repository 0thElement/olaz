import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:olaz/models/post.dart';
import 'package:olaz/models/user.dart';

class CommentController extends GetxController with StateMixin<List<Message>> {
  RxList<Message> comments = <Message>[].obs;

  PostCrud postCrud = Get.find();

  final RxBool _sending = false.obs;
  bool get sending => _sending.value;

  late Worker _worker;

  ScrollController scrollController = ScrollController();
  double currentScroll = 0;

  @override
  void onClose() {
    _worker.dispose();
    super.onClose();
  }

  int _limit = 30;
  static const int _limitIncrement = 30;

  void fetchMessages(String postId) async {
    change(null, status: RxStatus.loading());
    comments.bindStream(postCrud.roomMessageStream(postId, _limit));
    _worker = ever(comments, onCommentsChange);
  }

  void loadMore(String postId) {
    _limit += _limitIncrement;
    scrollController = ScrollController(initialScrollOffset: currentScroll);
    fetchMessages(postId);
  }

  void onCommentsChange(List<Message> list) {
    if (list.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(list, status: RxStatus.success());
      _limit = min(_limit, list.length);
    }
  }

  Future sendComment(String postId, String message,
      {List<String>? files}) async {
    String userId = Get.find<UserCrud>().currentUserId();
    String payload = message;

    if (message.contains('*')) {
      userId = message.split('*').first;
      payload = message.split('*').last;
    }

    comments.add(Message(
        payload: payload,
        sender: userId,
        createdAt: Timestamp.now(),
        files: files));

    _sending(true);
    await postCrud.comment(postId, userId, payload, files);
    _sending(false);
  }
}
