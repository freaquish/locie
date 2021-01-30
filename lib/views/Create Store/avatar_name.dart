import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';

class CreateStoreWidget extends StatefulWidget {
  @override
  _CreateStoreWidgetState createState() => _CreateStoreWidgetState();
}

class _CreateStoreWidgetState extends State<CreateStoreWidget> {
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);

    return Scaffold(
      appBar: Appbar().appbar(
        context: context,
        title: LatoText(
          'Create Store',
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
                          // image: DecorationImage(
                          //   image: AssetImage(),
                          // ),
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
                          onPressed: () {},
                        ))
                  ],
                ),
                SizedBox(
                  height: screen.vertical(50),
                ),
                TextBox(
                    textAlignment: TextAlign.left,
                    hintText: 'Store Name',
                    textController: null,
                    keyboard: TextInputType.name),
                SizedBox(
                  height: screen.vertical(200),
                ),
                SubmitButton(
                  //TODO run a function for next page
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      debugPrint('submit');
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
    );
  }
}
