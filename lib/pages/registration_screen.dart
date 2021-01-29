import 'package:flutter/material.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      body: PrimaryContainer(
        widget: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screen.vertical(200),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' Enter your \n Phone number',
                    style: TextStyle(color: Colors.white, fontSize: 36),
                  ),
                ),
                SizedBox(),
                Text('We \'ll text your verification code',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
