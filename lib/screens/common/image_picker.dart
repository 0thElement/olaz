import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  const UploadImage({ Key? key }) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  XFile? _image;
  List <XFile>? imageList = [];
  int type = 1;

  Future getImageFromGallery() async {
    final images = await ImagePicker().pickMultiImage();

    setState(() {
      if (images != null) {
        imageList!.addAll(images);
        type = 1;
      } else {
        print("No Image Selected");
      }
    });
  }

  Future getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = XFile(image.path);
        type = 2;
      } else {
        print("No Image Selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Choose your image source',
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: Center(
                child: _image == null ? const Text("No Image Selected") : 
                (type == 2 ? Image.network(_image!.path) : 
                Expanded(
                 child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: imageList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(imageList![index].path, fit: BoxFit.cover);
                    },
                  ),
                 ),
                )),
                // child: _image == null ? const Text("No Image Selected") : Image.file(File(_image!.path)),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: getImageFromCamera,
                tooltip: 'Choose Image From Camera',
                child: const Icon(Icons.camera),
              ),

              FloatingActionButton(
                onPressed: getImageFromGallery,
                tooltip: 'Choose Image From Galerry',
                child: const Icon(Icons.folder),
              ),
            ],
          )
        ],
      ),
    );
  }
}