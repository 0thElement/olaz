import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olaz/services/storage.dart';
import 'package:olaz/widgets/image_picker.dart';

class MessageBar extends StatefulWidget {
  final String hint;
  final TextEditingController textEditingController;
  final Function(String message, List<String>? files) onSend;
  const MessageBar(this.hint, this.textEditingController, this.onSend,
      {Key? key})
      : super(key: key);

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  bool shouldShowImagePicker = false;
  List<XFile>? selectedFiles;

  @override
  void initState() {
    shouldShowImagePicker = false;
    super.initState();
  }

  void showImagePicker() {
    setState(() {
      shouldShowImagePicker = !shouldShowImagePicker;
    });
  }

  void onSend() async {
    if (selectedFiles == null || selectedFiles!.isEmpty) {
      widget.onSend.call(widget.textEditingController.text, null);
      return;
    }

    List<String> uploaded = await StorageService.uploadAll(
        selectedFiles!.map((e) => e.path).toList());
    widget.onSend.call(widget.textEditingController.text, uploaded);

    setState(() {
      shouldShowImagePicker = false;
      selectedFiles = null;
    });
  }

  void onSelectedFilesChange(List<XFile> files) {
    selectedFiles = files;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: AnimatedSize(
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.2),
                    bottom: BorderSide(color: Colors.grey, width: 0.2))),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  Row(children: [
                    IconButton(
                        onPressed: showImagePicker,
                        icon: const Icon(Icons.add)),
                    //Text field
                    Expanded(
                      child: TextField(
                        controller: widget.textEditingController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: widget.hint,
                            border: InputBorder.none),
                        maxLines: null,
                      ),
                    ),
                    //Send Button
                    IconButton(
                        onPressed: onSend,
                        icon: const Icon(Icons.send, color: Colors.lightBlue))
                  ]),
                  shouldShowImagePicker
                      ? SizedBox(
                          height: 150,
                          child:
                              UploadImage(150, onChange: onSelectedFilesChange))
                      : const SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
