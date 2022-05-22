import 'package:flutter/material.dart';

class MessageBar extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final VoidCallback onSend;
  const MessageBar(this.hint, this.textEditingController, this.onSend,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        child: Row(children: [
          //More options button
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          //Text field
          Expanded(
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: hint,
                  border: InputBorder.none),
              maxLines: null,
            ),
          ),
          //Send Button
          IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send, color: Colors.lightBlue))
        ]),
      ),
    );
  }
}
