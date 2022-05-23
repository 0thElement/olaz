import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  const FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Full Photo',
          style: TextStyle(color: Color(0xff203152),)
        ),

        centerTitle: true,
      ),

      body: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}