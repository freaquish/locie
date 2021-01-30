import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';

class AddressWidget extends StatefulWidget {
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final TextEditingController textEditingControllerAddress1 =
      TextEditingController();
  final TextEditingController textEditingControllerAddress2 =
      TextEditingController();
  final TextEditingController textEditingControllerState =
      TextEditingController();
  final TextEditingController textEditingControllerPinCode =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    textEditingControllerAddress1.dispose();
    textEditingControllerAddress2.dispose();
    textEditingControllerState.dispose();
    textEditingControllerPinCode.dispose();

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
                vertical: screen.horizontal(2),
                horizontal: screen.horizontal(8)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(30),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      hintText: 'Address Line 1 *',
                      textController: textEditingControllerAddress1,
                      maxLength: 100,
                      minLines: 1,
                      maxLines: 4,
                      keyboard: TextInputType.multiline),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      hintText: 'Address Line 2',
                      maxLength: 100,
                      minLines: 1,
                      maxLines: 4,
                      textController: textEditingControllerAddress2,
                      keyboard: TextInputType.multiline),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      hintText: 'City or State *',
                      textController: textEditingControllerState,
                      keyboard: TextInputType.name),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      hintText: 'Pin Code *',
                      textController: textEditingControllerPinCode,
                      keyboard: TextInputType.number),
                  SizedBox(
                    height: screen.vertical(230),
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
      ),
    );
  }
}
