import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:olaz/models/message.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart';

class ChatController extends GetxController with StateMixin<List<Room>> {
  final Map<String, RxList<Message>> messages = {};
  RxList<Room> rooms = <Room>[].obs;

  late Worker _worker;

  MessageCrud messageCrud = Get.find();
  RoomCrud roomCrud = Get.find();
  UserCrud userCrud = Get.find();

  final RxBool _sending = false.obs;
  bool get sending => _sending.value;

  static const int initialLimit = 50;
  static const int limitIncrement = 50;

  final Map<String, int> roomMessagesLimit = {};

  final searchContactController = TextEditingController();

  final _debouncer = Debouncer(delay: Duration(milliseconds: 500));

  Future fetchMessages({String query = ""}) async {
    rooms.clear();
    String userId = userCrud.currentUserId();
    // Listen to changes in rooms list
    _worker = ever(rooms, onRoomListChange);
    change(null, status: RxStatus.loading());
    List<Room> roomList = await roomCrud.getRoomsOfUser(userId, query: query);
    roomList.forEach(addRoom);

    if (roomList.isEmpty) change(null, status: RxStatus.empty());
  }

  void addRoom(Room room) {
    messages[room.id] = <Message>[].obs;
    messages[room.id]!
        .bindStream(messageCrud.roomMessageStream(room.id, initialLimit));
    roomMessagesLimit[room.id] = initialLimit;
    rooms.add(room);
  }

  void loadMoreMessages(Room room) {
    int newLimit = roomMessagesLimit[room.id] ?? 0 + limitIncrement;
    roomMessagesLimit[room.id] = newLimit;
    messages[room.id]!
        .bindStream(messageCrud.roomMessageStream(room.id, newLimit));
  }

  void onRoomListChange(List<Room> roomList) {
    if (roomList.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(roomList, status: RxStatus.success());
    }
  }

  @override
  void onClose() {
    searchContactController.dispose();
    _worker.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    searchContactController.addListener(onSeachContactChange);
    super.onInit();
  }

  void onSeachContactChange() {
    _debouncer.call(() async {
      var value = searchContactController.value.text.trim();
      await fetchMessages(query: value);
    });
  }

  String optimizeRoomName(String roomName, String username) {
    print(roomName);
    print(username);
    var names = roomName.split(',').map((e) => e.trim());
    List<String> nameList = names.toList();
    if (names.length >= 2) {
      nameList.remove(username);
    }
    return nameList.join(', ');
  }

  Future<void> sendMessage(Room room, String message,
      {List<String>? files}) async {
    String userId = userCrud.currentUserId();
    String payload = message;

    if (message.contains('*')) {
      userId = message.split('*').first;
      payload = message.split('*').last;
    }

    messages[room.id]!.add(Message(
        payload: payload,
        sender: userId,
        createdAt: Timestamp.now(),
        files: files));

    _sending(true);
    await messageCrud.sendMessage(room.id, userId, payload, files);
    _sending(false);
  }

  Future<User> getUser(String userId) => userCrud.get(userId);
}
