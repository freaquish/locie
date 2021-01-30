import 'package:flutter/material.dart';
import 'package:locie/components/bottom_sheet.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String avatar;
  TextEditingController textEditingController = TextEditingController();
  final pickImage = PickImage();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff1f1e2c),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: PrimaryContainer(
            widget: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontal(4),
                        vertical: screen.horizontal(1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screen.vertical(200),
                        ),
                        CircleAvatar(
                          radius: screen.horizontal(20),
                          backgroundColor: Colors.white,
                          //TODO set a ternary operator for showing the image choosed
                          backgroundImage: AssetImage('assets/images/user.png'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: screen.horizontal(15),
                                width: screen.horizontal(39),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(screen.horizontal(22)),
                                    bottomRight:
                                        Radius.circular(screen.horizontal(22)),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // print('tap');
                                    final bottomSheet = BottomModalSheet(
                                        parentContext: context,
                                        height: screen.vertical(150),
                                        width: screen.horizontal(4),
                                        functionForCamera: pickImage.getImageFromCamera(),
                                        functionForGallery: pickImage.getImageFromGallery(),);
                                        bottomSheet.openBottomSheet();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(screen.horizontal(2)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.white,
                                        ),
                                        LatoText('Choose Image'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screen.vertical(50),
                        ),
                        TextBox(
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return 'Please Enter Name';
                            } else if (name.length < 3) {
                              return 'Name must be greator than 3 charactars';
                            } else if (name.length > 15) {
                              return 'Name must be less than 15 charactars';
                            }
                          },
                          textController: textEditingController,
                          hintText: 'Enter your name',
                          keyboard: TextInputType.text,
                          textAlignment: TextAlign.start,
                        ),
                        SizedBox(
                          height: screen.vertical(40),
                        ),
                        SubmitButton(
                          //TODO run a function to avatar and username to db
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              debugPrint('submit');
                              textEditingController.clear();
                            }
                          },
                          buttonName: 'Continue',
                          buttonColor: Color(0xff355cfd),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
