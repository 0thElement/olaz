import 'package:flutter/material.dart';

void toPhotoScreen(String url) {}

Widget filesView(List<String> files, {double height = 75}) {
  if (files.length == 1) {
    return GestureDetector(
      child: Image.network(files[0]),
      onTap: () => toPhotoScreen(files[0]),
    );
  } else {
    return SizedBox(
      height: height,
      child: ListView.builder(
          itemCount: files.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Row(
                children: [
                  GestureDetector(
                    child: Image.network(files[index]),
                    onTap: () => toPhotoScreen(files[index]),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              )),
    );
  }
}
