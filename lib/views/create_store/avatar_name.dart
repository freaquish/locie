import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/store.dart';

class CreateStoreWidget extends StatefulWidget {
  final CreateOrEditStoreBloc bloc;
  final Store store;
  CreateStoreWidget({this.bloc, this.store});
  @override
  _CreateStoreWidgetState createState() => _CreateStoreWidgetState();
}

class _CreateStoreWidgetState extends State<CreateStoreWidget> {
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final pickImage = PickImage();
  var image;

  @override
  void initState() {
    if (widget.store != null) {
      //(widget.store.name);
      textEditingController.value = TextEditingValue(text: widget.store.name);
      image = widget.store.image;
    }
    //(widget.store.toString() + "ans");
    super.initState();
  }

  ImageProvider imageProvider() {
    if (image is String) {
      return NetworkImage(image);
    }
    return FileImage(image);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);

    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return true;
      },
      child: Scaffold(
        appBar: Appbar().appbar(
          context: context,
          onTap: () {
            onBackClick(context);
          },
          title: LatoText(
            '${widget.store != null ? "Edit" : "Create"} Store',
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
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: screen.vertical(400),
                          width: screen.horizontal(100),
                          decoration: BoxDecoration(
                              image: image != null
                                  ? DecorationImage(
                                      image: imageProvider(), fit: BoxFit.cover)
                                  : null,
                              color: Colour.bgColor,
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
                                FocusScope.of(context).unfocus();
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
                                            borderRadius: new BorderRadius.only(
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
                                                        screen.horizontal(3)),
                                                    child: Text(
                                                      'Select Image',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontFamily: 'Mulish'),
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
                                                      color: Colors.grey[900],
                                                      fontSize: 14),
                                                ),
                                                leading: Icon(Icons.camera_alt,
                                                    color: Colors.grey[900]),
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
                                                      color: Colors.grey[900],
                                                      fontSize: 14),
                                                ),
                                                leading: Icon(Icons.image,
                                                    color: Colors.grey[900]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ))
                      ],
                    ),
                    SizedBox(
                      height: screen.vertical(50),
                    ),
                    CustomTextField(
                        textAlignment: TextAlign.left,
                        hintText: 'Store Name',
                        textController: textEditingController,
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                        },
                        keyboard: TextInputType.name),
                    SizedBox(
                      height: screen.vertical(200),
                    ),
                    SubmitButton(
                      //TODO run a function for next page
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            image != null &&
                            textEditingController.text.length > 3) {
                          debugPrint('submit');
                          Store store = Store();
                          if (widget.store != null) {
                            store = widget.store;
                          }
                          if (image is File) {
                            store.imageFile = image;
                          } else {
                            store.image = image;
                          }
                          store.name = textEditingController.value.text;
                          widget.bloc..add(ProceedToAddressPage(store));
                        }
                      },
                      buttonName: 'Continue',
                      buttonColor: Color(0xff355cfd),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
