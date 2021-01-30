import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';

class AddItemWidget extends StatefulWidget {
  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerDescription =
      TextEditingController();
  final pickImage = PickImage();
  var image;
  @override
  void dispose() {
    textEditingController.dispose();
    textEditingControllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(
        context: context,
        title: LatoText(
          '',
          size: 22,
          weight: FontWeight.bold,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PrimaryContainer(
          widget: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screen.horizontal(4),
                horizontal: screen.horizontal(8)),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      height: screen.vertical(390),
                      width: screen.horizontal(100),
                      decoration: BoxDecoration(
                          image: image != null ?  DecorationImage(
                            image:FileImage(image),
                            fit : BoxFit.fill
                          ) : null,
                          color: Color(0xff1f1e2c),
                          borderRadius: BorderRadius.all(
                              Radius.circular(screen.horizontal(4)))),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: screen.horizontal(8),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                                        enableDrag: false,
                                        context: context,
                                        builder: (builder) {
                                          return new Container(
                                            height: screen.vertical(250),
                                            color: Color(
                                                0xff1f1e2c), //Color(0xff111117),
                                            child: new Container(
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    new BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            screen
                                                                .horizontal(3)),
                                                        child: Text(
                                                          'Select Image',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'Mulish'),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.close,
                                                            color: Colors.red),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  ListTile(
                                                    onTap: () async {
                                                      var pickedimage =
                                                          await pickImage
                                                              .getImageFromCamera();
                                                      setState(() {
                                                        image = pickedimage;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[900],
                                                          fontSize: 14),
                                                    ),
                                                    leading: Icon(
                                                        Icons.camera_alt,
                                                        color:
                                                            Colors.grey[900]),
                                                  ),
                                                  ListTile(
                                                    onTap: () async {
                                                      var pickedimage =
                                                          await pickImage
                                                              .getImageFromGallery();

                                                      setState(() {
                                                        image = pickedimage;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[900],
                                                          fontSize: 14),
                                                    ),
                                                    leading: Icon(Icons.image,
                                                        color:
                                                            Colors.grey[900]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screen.vertical(50),
                ),
                TextBox(
                    textAlignment: TextAlign.left,
                    hintText: 'Item Name',
                    textController: textEditingController,
                     validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                    keyboard: TextInputType.name),
                    SizedBox(
                    height: screen.vertical(10),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      hintText: 'Description *',
                      maxLength: 150,
                      minLines: 5,
                      maxLines: 5,
                      textController: textEditingControllerDescription,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      keyboard: TextInputType.multiline),
                SizedBox(
                  height: screen.vertical(50),
                ),
                SubmitButton(
                  //TODO run a function for next page
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      debugPrint('submit');
                    }
                  },
                  buttonName: 'Next',
                  buttonColor: Color(0xff355cfd),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
