import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/pick_image.dart';
import 'package:locie/helper/screen_size.dart';

class ItemMetaDataWidget extends StatefulWidget {
  @override
  _ItemMetaDataWidgetState createState() => _ItemMetaDataWidgetState();
}

class _ItemMetaDataWidgetState extends State<ItemMetaDataWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerMax = TextEditingController();
  TextEditingController textEditingControllerMin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Color(0xff1f1e2c),
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
