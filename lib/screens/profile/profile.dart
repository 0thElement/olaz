import 'package:flutter/material.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/utils/extensions.dart';
import 'package:olaz/widgets/icon_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.user, Key? key}) : super(key: key);

  final User user;

  void toggleAddToContact() {}

  Widget avatar() {
    if (user.profilePicture == "")
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.lightBlue[100],
      );
    return CircleAvatar(
      radius: 80,
      backgroundImage: NetworkImage(user.profilePicture),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = user.name;
    String dateOfBirth = user.dateOfBirth?.toDate().format() ?? "Not provided";
    String phoneNumber =
        user.phoneNumber == "" ? "Not provided" : user.phoneNumber;
    String bio = user.bio == "" ? "Not provided" : user.bio;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: Column(children: [
              avatar(),
              const SizedBox(
                height: 20,
              ),
              Text(
                username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                onPressed: toggleAddToContact,
                child: iconText("Add to contact", Icons.person_add,
                    const TextStyle(color: Colors.white), Colors.white)),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: iconText(dateOfBirth, Icons.calendar_today,
                    TextStyle(color: Colors.grey[700]), Colors.grey[700]!,
                    align: TextAlign.center),
              ),
              Expanded(
                child: iconText(phoneNumber, Icons.phone,
                    TextStyle(color: Colors.grey[700]), Colors.grey[700]!,
                    align: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            bio,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ]),
      )),
    );
  }
}
