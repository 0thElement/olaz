import 'package:flutter/material.dart';
import 'package:olaz/widgets/icon_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void toggleAddToContact() {}

  final String username = "Username";
  final String dateOfBirth = "2000/1/1";
  final String phoneNumber = "0987654321";

  @override
  Widget build(BuildContext context) {
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
              const CircleAvatar(
                backgroundImage: NetworkImage(""),
                radius: 80,
              ),
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
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ]),
      )),
    );
  }
}
