import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCropperPage extends StatefulWidget {
  const ImageCropperPage({Key? key}) : super(key: key);

  @override
  State<ImageCropperPage> createState() => _ImageCropperPageState();
}

class _ImageCropperPageState extends State<ImageCropperPage> {

  File? imageFile;

  double multiple = 20;
  double width =  9;
  double height =  16;

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    width = width * multiple;
    height = height * multiple;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select & Crop Image'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            imageFile == null
                ? Image.asset('assets/no_profile_image.jpg', height: height, width: width,)
                : ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
                child: Image.file(imageFile!, height: height, width: width, fit: BoxFit.fill,)
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage, Permission.camera,
                ].request();
                if(statuses[Permission.storage]!.isGranted || statuses[Permission.camera]!.isGranted){
                  showImagePicker(context);
                } else {
                  print('no permission provided');
                }
              },
              child: Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          child: Column(
                            children: const [
                              Icon(Icons.image, size: 60.0,),
                              SizedBox(height: 12.0),
                              Text(
                                "Gallery",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              )
                            ],
                          ),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.pop(context);
                          },
                        )),
                    Expanded(
                        child: InkWell(
                          child: SizedBox(
                            child: Column(
                              children: const [
                                Icon(Icons.camera_alt, size: 60.0,),
                                SizedBox(height: 12.0),
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _imgFromCamera();
                            Navigator.pop(context);
                          },
                        ))
                  ],
                )),

          );
        }
    );
  }

  _imgFromGallery() async {
    await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    ).then((value){
      if(value != null){
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    ).then((value){
      if(value != null){
        _cropImage(File(value.path));
      }
    });
  }


Future<void> _cropImage(File imgFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imgFile.path,
    compressQuality: 50,
    aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16), // Set to 786x1024 aspect ratio
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: "Image Cropper",
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false, // Allow resizing while maintaining aspect ratio
      ),
      IOSUiSettings(
        title: "Image Cropper",
      ),
    ],
  );

  // If cropping is successful, update the image
  if (croppedFile != null) {
    setState(() {
      imageFile = File(croppedFile.path);
    });
  }
}



  // Future<void> _cropImage(File imgFile) async {
  //   final croppedFile = await ImageCropper().cropImage(
  //     sourcePath: imgFile.path,
  //     compressQuality: 50,
  //     aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16), // Set to 786x1024 aspect ratio
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: "Image Cropper",
  //         toolbarColor: Colors.deepOrange,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false, // Allow resizing while maintaining aspect ratio
  //       ),
  //       IOSUiSettings(
  //         minimumAspectRatio: 1.0,
  //         title: "Image Cropper",
  //       ),
  //     ],
  //   );

  //   // If cropping is successful, compress the image
  //   if (croppedFile != null) {
  //     File compressedFile = await _compressImage(File(croppedFile.path));
  //     setState(() {
  //       imageFile = compressedFile;
  //     });
  //   }
  // }

  // // Compress the cropped image using flutter_image_compress
  // Future<File> _compressImage(File image) async {
  //   final compressedImage = await FlutterImageCompress.compressWithFile(
  //     image.path,
  //     minWidth: 786,
  //     minHeight: 1024,
  //     quality: 95, // Adjust quality as needed
  //     rotate: 0, // No rotation
  //   );

  //   // Save the compressed image
  //   final tempDir = Directory.systemTemp;
  //   final targetPath = tempDir.absolute.path + "/compressed_image.jpg";
  //   final compressedFile = await File(targetPath).writeAsBytes(compressedImage!);

  //   return compressedFile;
  // }
}