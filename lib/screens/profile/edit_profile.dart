import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  void logout() {}

  void uploadAvatar() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: logout,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  basicInformation(constraints),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      label("Date of birth", constraints.maxWidth),
                      CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                          lastDate: DateTime.now(),
                          onDateChanged: (_) {}),
                      const SizedBox(
                        height: 20,
                      ),
                      label("Bio", constraints.maxWidth),
                      textField(TextEditingController(),
                          hint: "Describe yourself...",
                          inputType: TextInputType.multiline)
                    ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Row basicInformation(BoxConstraints constraints) {
    return Row(
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.4,
          child: Column(
            children: [
              GestureDetector(
                onTap: uploadAvatar,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(""),
                  radius: 50,
                ),
              ),
              TextButton(
                  onPressed: uploadAvatar,
                  child: const Text("Upload an avatar"))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20),
          width: constraints.maxWidth * 0.6,
          child: Column(
            children: [
              label("Name", constraints.maxWidth * 0.6),
              textField(TextEditingController(text: "Username"),
                  hint: "Username", inputType: TextInputType.name),
              const SizedBox(
                height: 20,
              ),
              label("Phone number", constraints.maxWidth * 0.6),
              textField(TextEditingController(text: "0987654321"),
                  inputType: TextInputType.phone)
            ],
          ),
        ),
      ],
    );
  }

  Widget label(String text, double width) {
    return SizedBox(
      child: Text(text,
          style: const TextStyle(
              color: Colors.lightBlue, fontWeight: FontWeight.w600)),
      width: width,
    );
  }

  Widget textField(TextEditingController controller,
      {String? hint,
      TextInputType inputType = TextInputType.text,
      int? multiline}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      textAlign: TextAlign.left,
      decoration: InputDecoration(hintText: hint),
      maxLines: multiline,
    );
  }
}
