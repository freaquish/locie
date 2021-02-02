import 'dart:io';

import 'package:flutter/material.dart';

class RichImage extends StatelessWidget {
  final dynamic image;
  const RichImage({this.image});

  ImageProvider getImage() {
    if (image is String && image.length > 0) {
      return NetworkImage(image);
    } else if (image is File) {
      return FileImage(image);
    }
    return AssetImage('assets/images/placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(image: getImage(), fit: BoxFit.cover)),
    );
  }
}
