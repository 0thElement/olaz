import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:olaz/models/room.dart';
import 'package:olaz/models/user.dart' as UserModel;

class ProfileController extends GetxController {
  UserModel.UserCrud userCrud = Get.find();
  RoomCrud roomCrud = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> addToContact(String friendId) async {
    if (FirebaseAuth.instance.currentUser == null) return Future.value();
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await userCrud.addFriend(currentUserId, friendId);
    var list = List<String>.empty(growable: true);
    list.add(currentUserId);
    list.add(friendId);
    await roomCrud.createRoom(list);
    return Future.value();
  }

  bool isFriend(UserModel.User friend) {
    if (FirebaseAuth.instance.currentUser == null) return false;

    return friend.friendIds.contains(FirebaseAuth.instance.currentUser!.uid);
  }
}
