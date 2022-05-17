import 'package:flutter/material.dart';
import 'package:olaz/widgets/icon_text.dart';

Color _color = Colors.grey[700]!;

PopupMenuItem createPopupItem(String text, String value, IconData icon) {
  return PopupMenuItem(
      child: iconText(text, icon, TextStyle(color: _color), _color),
      value: value);
}
