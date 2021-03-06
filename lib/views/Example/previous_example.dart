import 'package:flutter/material.dart';
import 'package:locie/bloc/previous_examples_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/get_it.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/models/store.dart';

class PreviousExampleWidget extends StatefulWidget {
  final PreviousExamplesBloc bloc;
  PreviousExampleWidget({this.bloc});
  @override
  _PreviousExampleWidgetState createState() => _PreviousExampleWidgetState();
}

class _PreviousExampleWidgetState extends State<PreviousExampleWidget> {
  var image;
  final pickImage = PickImage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerDescription =
      TextEditingController();

  @override
  void dispose() {
    textEditingControllerDescription.dispose();
    super.dispose();
  }

  void onBackClick(BuildContext context) {
    NavigationController.of(context).pop();
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
          onTap: () {
            onBackClick(context);
          },
          title: LatoText(
            'Previous Example',
            size: 18,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: PrimaryContainer(
            widget: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screen.horizontal(4),
                    horizontal: screen.horizontal(8)),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: screen.vertical(400),
                          width: screen.horizontal(100),
                          decoration: BoxDecoration(
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(image),
                                      fit: BoxFit.cover)
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
                      height: screen.vertical(40),
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextField(
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
                    ),
                    SizedBox(
                      height: screen.vertical(100),
                    ),
                    SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate() && image != null) {
                          debugPrint('submit');
                          widget.bloc
                            ..add(AddPreviousExample(PreviousExample(
                                text:
                                    textEditingControllerDescription.value.text,
                                imageFile: image)));
                        }
                      },
                      buttonName: 'Continue',
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
