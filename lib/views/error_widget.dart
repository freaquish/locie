import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      width: screen.horizontal(100),
      height: screen.vertical(1000),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/error_page.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screen.vertical(500),
          ),
          LatoText(
            'Opps !!!',
            weight: FontWeight.bold,
            size: 28,
          ),
          SizedBox(
            height: screen.vertical(20),
          ),
          LatoText(
            'Something went wrong .',
            fontColor: Colors.grey[300],
            size: 14,
          ),
          SizedBox(
            height: screen.vertical(30),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screen.vertical(0),
                horizontal: screen.horizontal(25)),
            child: SubmitButton(
                //TODO check error status
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).pop();
                },
                buttonName: 'Try Again',
                buttonColor: Colour.submitButtonColor),
          )
        ],
      ),
    );
  }
}
