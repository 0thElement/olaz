import 'package:flutter/material.dart';

Text iconText(String text, IconData icon, TextStyle textStyle, Color iconColor,
        {TextAlign align = TextAlign.left}) =>
    Text.rich(
      TextSpan(children: [
        WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            alignment: PlaceholderAlignment.middle),
        TextSpan(text: text)
      ]),
      textAlign: align,
      style: textStyle,
    );
