import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    fetchMessages();
    super.onInit();
  }

  Future fetchMessages() async {
    //TODO: GET CURRENT USER ID
    String userId = 'TEMPORARY';
    //Listen to changes in rooms list
    _worker = ever(rooms, onRoomListChange);
    change(null, status: RxStatus.loading());
    (await roomCrud.getRoomsOfUser(userId)).forEach(addRoom);
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
    _worker.dispose();
    super.onClose();
  }

  Future<void> sendMessage(Room room, String message,
      {List<String>? files}) async {
    // TODO: TEST ONLY
    String userId = 'TEMPORARY';
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

  Future<User> getUser(Message message) => userCrud.get(message.sender);
}
