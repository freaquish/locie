import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/listing_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';

class AddItemWidget extends StatefulWidget {
  Category category;
  Listing listing;
  final ListingBloc bloc;
  AddItemWidget({this.category, this.listing, this.bloc});
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
  void initState() {
    if (widget.listing != null) {
      textEditingController.value = TextEditingValue(text: widget.listing.name);
      textEditingControllerDescription.value =
          TextEditingValue(text: widget.listing.description);
      image = widget.listing.image.length > 0 ? widget.listing.image : null;
    }
    super.initState();
  }

  ImageProvider imageProvider() {
    if (image is String) {
      return NetworkImage(image);
    } else if (image is File) {
      return FileImage(image);
    }
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context)
        .replace(NavigateToSelectCategory());
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingControllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return false;
      },
      child: Scaffold(
        appBar: Appbar().appbar(
          context: context,
          onTap: () {
            onBackClick(context);
          },
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
                              showModalBottomSheet(
                                enableDrag: false,
                                context: context,
                                builder: (builder) {
                                  return new Container(
                                    height: screen.vertical(250),
                                    color: Colour.bgColor, //Color(0xff111117),
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
                                                MainAxisAlignment.spaceBetween,
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
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                          ListTile(
                                            onTap: () async {
                                              var pickedimage = await pickImage
                                                  .getImageFromCamera();
                                              setState(() {
                                                image = pickedimage;
                                                //printimage);
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
                                              var pickedimage = await pickImage
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
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screen.vertical(50),
                    ),
                    CustomTextField(
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
                    CustomTextField(
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
                          if (value.length > 150) {
                            return 'Description is greater than 150 character';
                          }
                        },
                        keyboard: TextInputType.multiline),
                    SizedBox(
                      height: screen.vertical(10),
                    ),
                    SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            textEditingController.text.length > 3) {
                          debugPrint('submit');
                          widget.listing.name = textEditingController.text;
                          widget.listing.description =
                              textEditingControllerDescription.text;
                          if (image is File) {
                            widget.listing.imageFile = image;
                          }
                          if (widget.category != null &&
                              widget.listing.id == null) {
                            widget.listing.parent = widget.category.id;
                            widget.listing.parentName = widget.category.name;
                            widget.listing.category = widget.category;
                          }
                          widget.bloc
                            ..add(ProceedToMetaDataPage(widget.listing));
                        }
                      },
                      buttonName: 'Next',
                      buttonColor: Colour.submitButtonColor,
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
