import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';

class MetaDataWidget extends StatefulWidget {
  @override
  _MetaDataWidgetState createState() => _MetaDataWidgetState();
}

class _MetaDataWidgetState extends State<MetaDataWidget> {
  final TextEditingController textEditingControllerGSTIN =
      TextEditingController();
  final TextEditingController textEditingControllerDescription =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    textEditingControllerGSTIN.dispose();
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
                      hintText: 'GSTIN *',
                      textController: textEditingControllerGSTIN,
                      maxLength: 40,
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
                    height: screen.vertical(380),
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
