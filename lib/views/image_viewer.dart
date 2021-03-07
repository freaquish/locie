import 'package:flutter/material.dart';
import 'package:locie/components/primary_container.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final ImageProvider provider;
  const ImageViewer(this.provider);
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      widget: Container(
        child: PhotoView(
          imageProvider: provider,
        ),
      ),
    );
  }
}
