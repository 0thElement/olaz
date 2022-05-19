import 'package:flutter/material.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/widgets/user_avatar.dart';

class UserSearchItem extends StatelessWidget {
  final User user;
  const UserSearchItem(this.user, {Key? key}) : super(key: key);

  Widget avatar(String id) => UserAvatar(
        id,
        20,
        interactable: true,
      );
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 12, bottom: 12),
              child: Row(
                children: [
                  avatar(user.id),
                  const SizedBox(
                    width: 20,
                  ),
                  //Name and newest latestMessage
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${user.name}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${user.bio}",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  //Last send time and unread
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
