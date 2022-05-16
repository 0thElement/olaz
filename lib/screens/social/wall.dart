import 'package:flutter/material.dart';
import 'package:olaz/widgets/message_bar.dart';
import 'package:olaz/widgets/popup_item.dart';
import 'package:olaz/widgets/post_item.dart';

class SocialWallScreen extends StatelessWidget {
  SocialWallScreen({Key? key}) : super(key: key);

  final TextEditingController messageTec = TextEditingController();

  List<PopupMenuItem> addPopupMenuButtonItems() {
    return [
      createPopupItem('Add a friend', 'friend', Icons.person_add_alt_rounded),
      createPopupItem('Create a group', 'group', Icons.group_add),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TextField(
            cursorColor: Colors.white70,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                border: InputBorder.none,
                hintText: 'Search for posts, users...',
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white70,
                ),
                itemBuilder: (context) {
                  return addPopupMenuButtonItems();
                })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return PostItem(
                        "Username",
                        "",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        DateTime.utc(2022, 4, 11, 16, 20),
                        DateTime.utc(2022, 4, 12, 3, 30),
                        5);
                  })),
            ),
            MessageBar("Share your thought...", messageTec, () {})
          ],
        ));
  }
}
