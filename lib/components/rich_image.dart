import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:skeleton_text/skeleton_text.dart';

class RichImage extends StatelessWidget {
  final dynamic image;
  final BorderRadius borderRadius;

  const RichImage({this.image, this.borderRadius});
  static String placeholder = 'assets/images/item_placeholder.png';

  static ImageProvider getImage_(dynamic image) {
    // final String placeholder = 'assets/images/item_placeholder.png';
    if (image is String && image.length > 0) {
      return NetworkImage(
        image,
      );
    } else if (image is File) {
      return FileImage(image);
    }
    return AssetImage(RichImage.placeholder);
  }

  ImageProvider getImage() {
    return RichImage.getImage_(image);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius != null
          ? borderRadius
          : BorderRadius.all(Radius.circular(8)),
      child: Image(
          image: getImage(),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SkeletonAnimation(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius != null
                    ? borderRadius
                    : BorderRadius.all(Radius.circular(15)),
                color: Colour.skeletonColor,
              ),
            ));
          },
          errorBuilder: (context, object, trace) => Image.asset(
                placeholder,
                fit: BoxFit.cover,
              )),
    );
  }
}
