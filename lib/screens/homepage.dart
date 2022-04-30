import 'package:flutter/material.dart';
import 'package:olaz/screens/chat/contact_list.dart';
import 'package:olaz/screens/login/login.dart';
import 'package:olaz/screens/social/wall.dart';
import 'package:olaz/screens/profile/profile.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _screenIndex = 0;
  final List<Widget> _screens = [
    ContactScreen(),
    SocialWallScreen(),
    ProfileScreen(),
    LoginPage(),
  ];

  void onItemSelected(index) {
    setState(() {
      _screenIndex = index;
    });
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
    return Scaffold(
      body: _screens[_screenIndex],
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _screenIndex,
          onItemSelected: onItemSelected,
          items: [
            createItem(
                'Contact',
                _screenIndex == 0
                    ? Icons.chat_bubble
                    : Icons.chat_bubble_outline),
            createItem(
                'Social',
                _screenIndex == 1
                    ? Icons.people_alt
                    : Icons.people_alt_outlined),
            createItem(
                'Profile',
                _screenIndex == 2
                    ? Icons.account_circle
                    : Icons.account_circle_outlined),
            createItem(
                'Login',
                _screenIndex == 3
                    ? Icons.add_circle
                    : Icons.add_circle_outlined),
          ]),
    );
  }
}
