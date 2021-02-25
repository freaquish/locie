import 'package:flutter/material.dart';
import 'package:locie/bloc/authentication_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/country_codes.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/text_field.dart';

class PhoneAuthenticationWidget extends StatefulWidget {
  final AuthenticationBloc bloc;
  final bool error;
  PhoneAuthenticationWidget({this.bloc, this.error = false});
  @override
  _PhoneAuthenticationWidgetState createState() =>
      _PhoneAuthenticationWidgetState();
}

class _PhoneAuthenticationWidgetState extends State<PhoneAuthenticationWidget> {
  String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  String countryCode = "91";

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screen.vertical(60),
                      ),
                      if (widget.error)
                        Container(
                          // color: Colors.red,
                          width: screen.horizontal(100),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(
                              vertical: screen.vertical(20)),
                          child: LatoText(
                            'Phone Authentication failed',
                            size: 16,
                            fontColor: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: screen.vertical(100),
                      ),
                      RailwayText(
                        'Enter your \nPhone number',
                        size: 36,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: screen.vertical(30),
                      ),
                      LatoText(
                        'We \'ll text your verification code',
                        size: 18,
                        fontColor: Colors.grey,
                      ),
                      SizedBox(
                        height: screen.vertical(35),
                      ),
                      CustomTextField(
                        preffixWidget: Wrap(
                          spacing: screen.horizontal(1),
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
                                          ));
                                },
                                child: LatoText(
                                  '+$countryCode',
                                  size: 18,
                                  fontColor: Colors.grey,
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
                        hintText: 'Phone Number',
                        keyboard: TextInputType.phone,
                        textAlignment: TextAlign.start,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            debugPrint('submit');
                            var phoneNumber = textEditingController.value.text;

                            textEditingController.clear();
                            // //printcountryCode + phoneNumber);
                            widget.bloc
                              ..add(ProceedToOtpPage(
                                  '+$countryCode$phoneNumber'));
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
