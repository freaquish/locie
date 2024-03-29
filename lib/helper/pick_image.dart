import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickImage {
  final picker = ImagePicker();
  File image;

  Future<dynamic> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    return image;
  }

  Future<dynamic> getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    return image;
  }
}
