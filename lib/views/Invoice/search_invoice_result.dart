import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';

class SearchInVoiceResult extends StatefulWidget {
  @override
  _SearchInVoiceResultState createState() => _SearchInVoiceResultState();
}

class _SearchInVoiceResultState extends State<SearchInVoiceResult> {
  bool isUserFound = false;

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
        appBar: Appbar().appbar(title: LatoText('')),
        body: isUserFound
            ? buildUserFoundScreen(screen)
            : buildUserNotFoundScreen(screen));
  }

  PrimaryContainer buildUserNotFoundScreen(Scale screen) {
    return PrimaryContainer(
      widget: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screen.horizontal(4), vertical: screen.horizontal(1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screen.vertical(50),
            ),
            Container(
              height: screen.vertical(370),
              width: screen.horizontal(100),
              child: Card(
                color: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screen.horizontal(4),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screen.horizontal(8)),
                      child: LatoText(
                        'User with phone number +918574047383 not found !!',
                        size: 21,
                      ),
                    ),
                    SizedBox(
                      height: screen.vertical(40),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screen.horizontal(5)),
                      child: SubmitButton(
                        onPressed: () {},
                        buttonName: 'Create Invoice',
                        buttonColor: Color(0xff355cfd),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PrimaryContainer buildUserFoundScreen(Scale screen) {
    return PrimaryContainer(
      widget: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screen.horizontal(4), vertical: screen.horizontal(1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screen.vertical(200),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: screen.horizontal(12),
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
              title: LatoText(
                'Piyush Jaiswal',
                size: 18,
              ),
            ),
            SizedBox(
              height: screen.vertical(60),
            ),
            SubmitButton(
              onPressed: () {},
              buttonName: 'Continue',
              buttonColor: Color(0xff355cfd),
            )
          ],
        ),
      ),
    );
  }
}
