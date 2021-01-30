import 'package:flutter/material.dart';

class BottomModalSheet {
  final BuildContext parentContext;
  final double height;
  final double width;
  final functionForGallery;
  final functionForCamera;
  BottomModalSheet({
    @required this.parentContext,
    @required this.height,
    @required this.width,
    @required this.functionForGallery,
    @required this.functionForCamera,
  });
  openBottomSheet() {
    return showModalBottomSheet(
        enableDrag: false,
        context: parentContext,
        builder: (builder) {
          BuildContext context;
          return new Container(
            height: height * 250,
            color: Color(0xff767676),
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width * 4),
                        child: Text(
                          'Select Image',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Mulish'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  ListTile(
                    onTap: () async {
                      functionForCamera();
                      Navigator.pop(context);
                    },
                    title: Text(
                      'Camera',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    leading: Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                  ListTile(
                    onTap: () async {
                      functionForGallery();
                      Navigator.pop(context);
                    },
                    title: Text(
                      'Gallery',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    leading: Icon(Icons.image, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
