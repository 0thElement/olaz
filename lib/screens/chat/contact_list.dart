import 'package:flutter/material.dart';
import 'package:olaz/widgets/contact_item.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<PopupMenuItem> addPopupMenuButtonItems() {
    return [
      createPopupItem('Add a friend', 'friend', Icons.person_add_alt_rounded),
      createPopupItem('Create a group', 'group', Icons.group_add),
    ];
  }

  PopupMenuItem createPopupItem(String text, String value, IconData icon) {
    return PopupMenuItem(
        child: Text.rich(
          TextSpan(children: [
            WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    icon,
                    color: Colors.grey[700],
                  ),
                ),
                alignment: PlaceholderAlignment.middle),
            TextSpan(text: text)
          ]),
          style: TextStyle(color: Colors.grey[700]),
        ),
        value: value);
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
                hintText: 'Search for contact',
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.add),
                itemBuilder: (context) {
                  return addPopupMenuButtonItems();
                })
          ],
        ),
        body: (ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              return ContactItem(
                  "name",
                  "hi",
                  "https://thumbs.dreamstime.com/b/woman-praying-free-birds-to-nature-sunset-background-woman-praying-free-birds-enjoying-nature-sunset-99680945.jpg",
                  "1h",
                  index);
            }))));
  }
}
