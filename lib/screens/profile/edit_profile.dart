import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olaz/controllers/login_controller.dart';
import 'package:olaz/models/user.dart';
import 'package:olaz/services/storage.dart';
import 'package:olaz/widgets/image_picker.dart';
import 'package:olaz/widgets/user_avatar.dart';

class EditProfileScreenController extends GetxController {
  Rx<DateTime> selectedDateOfBirth = DateTime.now().obs;

  Rx<User?> user = User.emptyUser.obs;

  final TextEditingController nameTec = TextEditingController();
  final TextEditingController phoneTec = TextEditingController();
  final TextEditingController bioTec = TextEditingController();

  UserCrud userCrud = Get.find();

  Future save(bool isNewUser) async {
    user.value!.bio = bioTec.text;
    user.value!.phoneNumber = phoneTec.text;
    user.value!.name = nameTec.text;
    user.value!.dateOfBirth = Timestamp.fromDate(selectedDateOfBirth.value);
    if (selectedAvatar.value != null) {
      String url = await StorageService.upload(selectedAvatar.value!.path);
      user.value!.profilePicture = url;
    }
    await Get.find<UserCrud>().save(user.value!.id, user.value!);
    if (isNewUser) Get.offAllNamed('/home');

    selectedAvatar.value = null;

    Get.snackbar('Successful', 'Your profile was updated');
  }

  Future getUserData(bool isNewUser) async {
    var firebaseUser = firebase.FirebaseAuth.instance.currentUser!;
    if (isNewUser) {
      user(User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'New user',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          profilePicture: firebaseUser.photoURL ?? ''));
    } else {
      user(await userCrud.get(firebaseUser.uid));
    }
    DateTime dateOfBirth = user.value!.dateOfBirth == null
        ? DateTime.now()
        : user.value!.dateOfBirth!.toDate();
    selectedDateOfBirth(dateOfBirth);
    nameTec.text = user.value!.name;
    phoneTec.text = user.value!.phoneNumber;
    bioTec.text = user.value!.bio;
  }

  Rxn<XFile> selectedAvatar = Rxn<XFile>();

  void onSelectedAvatarChange(List<XFile> files) {
    if (files.isEmpty) return;
    selectedAvatar(files[0]);
  }

  void cancelAvatarChange() {
    selectedAvatar(null);
  }
}

class EditProfileScreen extends GetView<EditProfileScreenController> {
  const EditProfileScreen({this.isNewUser = false, Key? key}) : super(key: key);

  final bool isNewUser;

  void logout() {
    Get.find<LoginController>().signOut();
  }

  void save() {
    controller.save(isNewUser);
  }

  DateTime currentDateOfBirth() {
    Timestamp timestamp = controller.user.value?.dateOfBirth ?? Timestamp.now();
    return timestamp.toDate();
  }

  void uploadAvatar() {
    Get.defaultDialog(
        title: "Select avatar",
        cancel: OutlinedButton(
            onPressed: () {
              controller.cancelAvatarChange();
              Get.back();
            },
            child: const Text("Cancel")),
        confirm: ElevatedButton(
            onPressed: Get.back,
            child:
                const Text("Confirm", style: TextStyle(color: Colors.white))),
        content: Container(
          child: UploadImage(500,
              onChange: controller.onSelectedAvatarChange, single: true),
        ));
  }

  @override
  Widget build(BuildContext context) {
    controller.getUserData(isNewUser);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: save,
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                )),
            isNewUser
                ? const SizedBox()
                : IconButton(
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
                      Obx(() => CalendarDatePicker(
                          initialDate: controller.selectedDateOfBirth.value,
                          firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                          lastDate: DateTime.now(),
                          onDateChanged: (value) {
                            controller.selectedDateOfBirth(value);
                          })),
                      const SizedBox(
                        height: 20,
                      ),
                      label("Bio", constraints.maxWidth),
                      textField(controller.bioTec,
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
                  child: Obx(() => controller.selectedAvatar.value == null
                      ? UserAvatar(controller.user.value?.id, 50)
                      : CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: Image.file(
                              File(controller.selectedAvatar.value!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          )))),
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
              textField(controller.nameTec,
                  hint: "Username", inputType: TextInputType.name),
              const SizedBox(
                height: 20,
              ),
              label("Phone number", constraints.maxWidth * 0.6),
              textField(controller.phoneTec, inputType: TextInputType.phone)
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
