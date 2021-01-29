import 'package:flutter/material.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/views/verify_otp.dart';

class PhoneAuthenticationWidget extends StatefulWidget {
  @override
  _PhoneAuthenticationWidgetState createState() => _PhoneAuthenticationWidgetState();
}

class _PhoneAuthenticationWidgetState extends State<PhoneAuthenticationWidget> {
  String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screen.vertical(200),
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
                      TextBox(
                        preffixWidget: Padding(
                          padding: EdgeInsets.only(
                              left: screen.horizontal(3),
                              top: screen.horizontal(2.91),
                              bottom: screen.horizontal(2.91)),
                          child: LatoText(
                            '+91',
                            size: 18,
                            fontColor: Colors.grey,
                          ),
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
                        textAlignment: TextAlign.center,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                         //TODO run a function for send OTP
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            debugPrint('submit');
                            textEditingController.clear();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpScreen()));
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
