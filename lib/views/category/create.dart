import 'package:flutter/material.dart';
import 'package:locie/bloc/category_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/category.dart';

class CreateNewCategoryWidget extends StatefulWidget {
  final Category current;
  final CategoryBloc bloc;
  CreateNewCategoryWidget({this.bloc, this.current});
  @override
  _CreateNewCategoryWidgetState createState() =>
      _CreateNewCategoryWidgetState();
}

class _CreateNewCategoryWidgetState extends State<CreateNewCategoryWidget> {
  TextEditingController nameTextController = TextEditingController();
  var image;
  final _formKey = GlobalKey<FormState>();
  final pickImage = PickImage();
  LocalStorage localStorage = LocalStorage();

  void onCreateClick() async {
    if (widget.current != null && nameTextController.text.isNotEmpty) {
      var sid = localStorage.prefs.getString("sid");
      Category category = Category(
          parent: widget.current.id,
          store: sid,
          isDefault: false,
          name: nameTextController.value.text,
          imageFile: image,
          defaultParent: widget.current.defaultParent == null
              ? widget.current.id
              : widget.current.defaultParent);
      widget.bloc..add(CreateCategory(category));
    }
  }

  @override
  Widget build(BuildContext context) {
    Scale screen = Scale(context);
    return SafeArea(
      top: true,
      child: Padding(
        padding: EdgeInsets.only(top: screen.vertical(6)),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: PrimaryContainer(
              widget: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screen.vertical(10),
                    horizontal: screen.horizontal(0)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 28.0,
                          color: Colors.white,
                          onPressed: () {
                            widget.bloc..add(CreateNewToSelection());
                          },
                        ),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screen.vertical(20),
                                horizontal: screen.horizontal(4)),
                            child: Container(
                              height: screen.vertical(390),
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
                                        color:
                                            Colour.bgColor, //Color(0xff111117),
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
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screen.vertical(50),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screen.horizontal(4)),
                        child: CustomTextField(
                            textAlignment: TextAlign.left,
                            hintText: 'Category Name',
                            textController: nameTextController,
                            validator: (value) {
                              if (value.isEmpty || value == null) {
                                return 'Required field';
                              }
                            },
                            keyboard: TextInputType.name),
                      ),
                      SizedBox(
                        height: screen.vertical(50),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screen.horizontal(4)),
                        child: SubmitButton(
                          buttonColor: Colour.submitButtonColor,
                          buttonName: 'Create',
                          onPressed: () {
                            onCreateClick();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
