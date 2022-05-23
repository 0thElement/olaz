import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olaz/models/user.dart' as olaz;
import 'package:olaz/screens/chat/contact_list.dart';
import 'package:olaz/screens/common/image_picker_screen.dart';
import 'package:olaz/screens/social/wall.dart';
import 'package:olaz/screens/profile/edit_profile.dart';

class HomePageController extends GetxController {
  List<Widget> screens = [
    const ContactScreen(),
    SocialWallScreen(),
    const EditProfileScreen(),
    const UploadImageScreen(),
  ];
  RxInt screenIndex = 0.obs;
  olaz.UserCrud userCrud = Get.find();

  Widget get currentScreen => screens[screenIndex.value];

  Future checkUser() async {
    User user = FirebaseAuth.instance.currentUser!;

    if (!await userCrud.userExists(user.uid)) {
      Get.offAll(const EditProfileScreen(isNewUser: true));
    }
  }
}

class HomePage extends GetView<HomePageController> {
  const HomePage({Key? key}) : super(key: key);

  void onItemSelected(index) {
    controller.screenIndex(index);
  }

  BottomNavyBarItem createItem(String title, IconData icon) {
    return BottomNavyBarItem(
        icon: Icon(icon),
        title: Text(title),
        activeColor: Colors.lightBlue,
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    controller.checkUser();
    controller.screenIndex(0);
    return Obx(() => Scaffold(
          body: controller.currentScreen,
          bottomNavigationBar: BottomNavyBar(
              selectedIndex: controller.screenIndex.value,
              onItemSelected: onItemSelected,
              items: [
                createItem(
                    'Contact',
                    controller.screenIndex.value == 0
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline),
                createItem(
                    'Social',
                    controller.screenIndex.value == 1
                        ? Icons.people_alt
                        : Icons.people_alt_outlined),
                createItem(
                    'Profile',
                    controller.screenIndex.value == 2
                        ? Icons.account_circle
                        : Icons.account_circle_outlined),
                createItem(
                    'Upload Image',
                    controller.screenIndex.value == 3
                        ? Icons.image
                        : Icons.image_outlined),
              ]),
        ));
  }
}
