import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget {
  const UploadImage(this.maxHeight,
      {this.single = false, this.onChange, Key? key})
      : super(key: key);

  final double maxHeight;
  final bool single;
  final Function(List<XFile>)? onChange;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<XFile> imageList = [];
  Future getImageFromGallery() async {
    if (!widget.single) {
      final images = await ImagePicker().pickMultiImage();
      setState(() {
        if (images != null) {
          imageList.addAll(images);
        }
        widget.onChange?.call(imageList);
      });
    } else {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (image != null) {
          imageList = [image];
        }
        widget.onChange?.call(imageList);
      });
    }
  }

  Future getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        if (!widget.single) {
          imageList.add(image);
        } else {
          imageList = [image];
        }
        widget.onChange?.call(imageList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: widget.maxHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(5),
              width: availableWidth,
              height: widget.maxHeight - 50,
              child: Center(
                child: imageList.isEmpty
                    ? const Text(
                        "No Image Selected",
                        style: TextStyle(color: Colors.grey),
                      )
                    : (Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.single
                            ? Image.file(File(imageList[0].path))
                            : GridView.builder(
                                itemCount: imageList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => setState(() {
                                      imageList.removeAt(index);
                                    }),
                                    child: Image.file(
                                      File(imageList[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                      )),
              ),
            )),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: availableWidth / 3,
                  child: ElevatedButton(
                    onPressed: getImageFromCamera,
                    // tooltip: 'Choose Image From Camera',
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: availableWidth / 3,
                    child: ElevatedButton(
                      onPressed: getImageFromGallery,
                      // tooltip: 'Choose Image From Galerry',
                      child: const Icon(
                        Icons.folder,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
