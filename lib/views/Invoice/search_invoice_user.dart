import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/country_codes.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';

class SearchInvoiceUser extends StatefulWidget {
  @override
  _SearchInvoiceUserState createState() => _SearchInvoiceUserState();
}

class _SearchInvoiceUserState extends State<SearchInvoiceUser> {
  String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  String countryCode = "91";

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(title: LatoText('')),
      body: PrimaryContainer(
        widget: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screen.horizontal(4),
                    vertical: screen.horizontal(1)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screen.vertical(170),
                      ),
                      RailwayText(
                        'Create \nNew Invoice',
                        size: 36,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: screen.vertical(30),
                      ),
                      CustomTextField(
                        preffixWidget: Wrap(
                          spacing: 4,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screen.horizontal(3),
                                  right: screen.horizontal(1),
                                  top: screen.horizontal(2.91),
                                  bottom: screen.horizontal(2.91)),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CountryCodeModel(
                                      onChange: (value) {
                                        setState(() {
                                          countryCode = value;
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                                child: LatoText(
                                  '+$countryCode',
                                  size: 18,
                                  fontColor: Colors.grey[300],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screen.horizontal(3),
                                  top: screen.horizontal(2.91),
                                  bottom: screen.horizontal(2.91)),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => CountryCodeModel(
                                            onChange: (value) {
                                              setState(() {
                                                countryCode = value;
                                              });

                                              Navigator.of(context).pop();
                                            },
                                          ));
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        validator: (phoneNumber) {
                          if (phoneNumber == null || phoneNumber.isEmpty) {
                            return 'Please Enter Phone Number';
                          } else if (phoneNumber.length > 10 ||
                              phoneNumber.length < 10) {
                            return 'Enter valid Phone Number';
                          }
                        },
                        textController: textEditingController,
                        hintText: 'Customer Phone Number',
                        keyboard: TextInputType.phone,
                        textAlignment: TextAlign.start,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            var phoneNumber = textEditingController.value.text;
                            textEditingController.clear();
                          }
                        },
                        buttonName: 'Continue',
                        buttonColor: Color(0xff355cfd),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
