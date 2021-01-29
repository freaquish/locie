import 'package:flutter/material.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';

class VerifyOtpScreen extends StatefulWidget {
  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  String otp;
  bool resendOtp;
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
        onTap: (){
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
                        height: screen.vertical(20),
                      ),
                      IconButton(
                        iconSize : screen.horizontal(7),
                        padding: EdgeInsets.all(0),
                        alignment: Alignment.centerLeft,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                        )
                      ),
                      SizedBox(
                        height: screen.vertical(140),
                      ),
                      RailwayText(
                        'Verification Code',
                        size: 36,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: screen.vertical(30),
                      ),
                      LatoText(
                        'Please type the verification code\nsent to 8574047383',
                        size: 18,
                        fontColor: Colors.grey,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      TextBox(
                         validator: (otp) {
                          if (otp == null || otp.isEmpty) {
                            return 'Please Enter OTP';
                          } else if (otp.length > 6 ||
                              otp.length < 6) {
                            return 'Enter valid OTP';
                          }
                        },
                        textController: textEditingController,
                        hintText: 'Enter OTP',
                        keyboard: TextInputType.phone,
                        textAlignment: TextAlign.center,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                        //TODO run a function for verifying
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            setState(() {
                              resendOtp = false;
                            });
                          
                            debugPrint('submit');
                            
                          }
                        },
                        buttonName: 'Verify',
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