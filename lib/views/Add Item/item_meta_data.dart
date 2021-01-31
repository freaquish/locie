import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/switch_button.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';

class ItemMetaDataWidget extends StatefulWidget {
  @override
  _ItemMetaDataWidgetState createState() => _ItemMetaDataWidgetState();
}

class _ItemMetaDataWidgetState extends State<ItemMetaDataWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerMax = TextEditingController();
  TextEditingController textEditingControllerMin = TextEditingController();
  List units = [];
  String unit = 'kg';
  bool _enable = true;
  bool isListLoaded = false;
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: PrimaryContainer(
            widget: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screen.horizontal(4),
                  horizontal: screen.horizontal(6)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screen.vertical(60),
                    ),
                    RailwayText(
                      'Price',
                      size: 32,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: screen.vertical(50),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screen.horizontal(40),
                            child: TextBox(
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return 'Required field';
                                  }
                                },
                                textAlignment: TextAlign.start,
                                hintText: 'Max',
                                maxLines: 3,
                                minLines: 2,
                                textController: textEditingControllerMax,
                                keyboard: TextInputType.number),
                          ),
                          Container(
                            width: screen.horizontal(40),
                            child: TextBox(
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return 'Required field';
                                  }
                                },
                                textAlignment: TextAlign.start,
                                hintText: 'Min',
                                maxLines: 3,
                                minLines: 2,
                                textController: textEditingControllerMin,
                                keyboard: TextInputType.number),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screen.vertical(50),
                    ),
                    Container(
                      height: screen.vertical(110),
                      width: screen.horizontal(100),
                      decoration: BoxDecoration(
                          color: Color(0xff5c5c5c),
                          borderRadius: BorderRadius.all(
                              Radius.circular(screen.horizontal(4)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: screen.horizontal(3.5)),
                            child: LatoText(
                              'Item in Stock',
                              size: 20,
                              fontColor: Colors.grey[200],
                              weight: FontWeight.normal,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: screen.horizontal(2.5)),
                            child: CustomSwitch(
                              value: _enable,
                              onChanged: (bool val) {
                                setState(() {
                                  _enable = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screen.vertical(280),
                    ),
                    SubmitButton(
                      //TODO run a function for next page
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          debugPrint('submit');
                        }
                      },
                      buttonName: 'Done',
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
