import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  double multiple = 20;
  double width = 9;
  double height = 16;

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    width = width * multiple;
    height = height * multiple;
  }

  File? imageFile;
  Future<void> pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imageFile = File(image.path);
        });
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          imageFile = File(image.path);
        });
      } else {
        // Handle if the user cancels the camera picker
        print("No image captured");
      }
    } catch (e) {
      print("Error picking image from camera: $e");
      // Handle any error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Image Picker Testing"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(width: 5, color: Colors.amber)),
              child: imageFile == null
                  ? const Center(child: Text("No Image Selected"))
                  : Image.file(imageFile!),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    pickImageFromGallery();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.amber,
                    ),
                    child: const Center(child: Icon(Icons.photo_library)),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                InkWell(
                  onTap: () {
                    pickImageFromCamera();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber,
                    ),
                    child: const Center(child: Icon(Icons.camera_alt_outlined)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}