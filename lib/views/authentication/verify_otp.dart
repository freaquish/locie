import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locie/bloc/authentication_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/firestore_auth.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';

class VerifyOtpScreen extends StatefulWidget {
  final AuthenticationBloc bloc;
  final PhoneAuthentication auth;
  VerifyOtpScreen({this.auth, this.bloc});
  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String otp;
  bool resendOtp;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  int timeLeft = 120;
  Timer timer;
  final oneSecond = Duration(seconds: 1);

  void retry() {
    widget.bloc..add(InitiateLogin());
  }

  @override
  void initState() {
    timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        // this.timer = timer;
        timeLeft -= 1;
        if (timeLeft == 0) {
          timer.cancel();
        }
      });
    });
    super.initState();
  }

  String getTimer() {
    if (timeLeft > 0) {
      return timeLeft.toString() + ' ';
    }
    return '';
  }

  @override
  void dispose() {
    textEditingController.dispose();
    timer.cancel();
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
                        height: screen.vertical(20),
                      ),
                      IconButton(
                          iconSize: screen.horizontal(7),
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.centerLeft,
                          onPressed: () {
                            // Navigator.pop(context);
                            widget.bloc..add(InitiateLogin());
                          },
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.white,
                          )),
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
                        'Please type the verification code\nsent to ${widget.auth.phoneNumber}',
                        size: 18,
                        fontColor: Colors.grey,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      CustomTextField(
                        validator: (otp) {
                          if (otp == null || otp.isEmpty) {
                            return 'Please Enter OTP';
                          } else if (otp.length > 6 || otp.length < 6) {
                            return 'Enter valid OTP';
                          }
                        },
                        preffixWidget: (widget.auth.verificationId == null)
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(),
                              )
                            : null,
                        textController: textEditingController,
                        hintText: 'Enter OTP',
                        keyboard: TextInputType.phone,
                        textAlignment: TextAlign.center,
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              widget.auth.verificationId != null) {
                            setState(() {
                              resendOtp = false;
                            });

                            debugPrint('submit');
                            widget.bloc
                              ..add(AuthenticateUser(widget.auth,
                                  textEditingController.value.text));
                          }
                        },
                        buttonName: 'Verify',
                        buttonColor: Color(0xff355cfd),
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      SubmitButton(
                        onPressed: () {
                          if (timeLeft == 0) {
                            textEditingController.clear();
                            retry();
                          }
                        },
                        buttonName: '${getTimer()}Retry',
                        buttonColor: Colour.bgColor,
                        textColor: Colour.submitButtonColor,
                      ),
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
