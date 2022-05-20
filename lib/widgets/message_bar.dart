import 'package:flutter/material.dart';
import 'package:olaz/widgets/image_picker.dart';

class MessageBar extends StatefulWidget {
  final String hint;
  final TextEditingController textEditingController;
  final VoidCallback onSend;
  final VoidCallback onFocus;
  const MessageBar(
      this.hint, this.textEditingController, this.onSend, this.onFocus,
      {Key? key})
      : super(key: key);

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  bool shouldShowImagePicker = false;

  void showImagePicker() {
    setState(() {
      shouldShowImagePicker = !shouldShowImagePicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: AnimatedSize(
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
          child: Container(
            constraints: BoxConstraints(
                minHeight: 50, maxHeight: shouldShowImagePicker ? 50 : 200),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(children: [
                    IconButton(
                        onPressed: showImagePicker,
                        icon: const Icon(Icons.add)),
                    //Text field
                    Expanded(
                      child: TextField(
                        onTap: widget.onFocus,
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
                        onPressed: widget.onSend,
                        icon: const Icon(Icons.send, color: Colors.lightBlue))
                  ]),
                  shouldShowImagePicker
                      ? const SizedBox(
                          height: 0,
                        )
                      : const SizedBox(height: 150, child: UploadImage(150))
                ],
              ),
            ),
          ),
        ));
  }
}
