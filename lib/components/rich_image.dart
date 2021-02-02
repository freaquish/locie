import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:skeleton_text/skeleton_text.dart';

class RichImage extends StatelessWidget {
  final dynamic image;
  final BorderRadius borderRadius;

  const RichImage({this.image, this.borderRadius});
  final String placeholder = 'assets/images/placeholder.png';

  ImageProvider getImage() {
    if (image is String && image.length > 0) {
      return NetworkImage(
        image,
      );
    } else if (image is File) {
      return FileImage(image);
    }
    return AssetImage(placeholder);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: borderRadius != null
  //             ? borderRadius
  //             : BorderRadius.all(Radius.circular(8)),
  //         image: DecorationImage(image: getImage(), fit: BoxFit.cover)),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius != null
          ? borderRadius
          : BorderRadius.all(Radius.circular(8)),
      child: Image(
          image: getImage(),
          fit: BoxFit.fill,
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
