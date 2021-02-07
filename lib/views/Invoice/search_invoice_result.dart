import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/invoice.dart';

class SearchInVoiceResult extends StatefulWidget {
  final Account account;
  final String phoneNumber;
  SearchInVoiceResult({this.account, this.phoneNumber});
  @override
  _SearchInVoiceResultState createState() => _SearchInVoiceResultState();
}

class _SearchInVoiceResultState extends State<SearchInVoiceResult> {
  bool isUserFound = false;

  @override
  void initState() {
    // //(widget.account);
    nameTextController = TextEditingController();
    isUserFound = widget.account != null;
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<InvoiceBloc>(context)
      ..add(InvoiceCustomerPhoneInputPageLaunch());
  }

  TextEditingController nameTextController;

  void onContinueClick(BuildContext context) {
    //('clicked');
    Invoice invoice = Invoice(recipientPhoneNumber: widget.phoneNumber);
    if (widget.account != null) {
      invoice.recipient = widget.account.uid;
      invoice.recipientName = widget.account.name;
    } else {
      invoice.recipientName = nameTextController.text;
    }
    BlocProvider.of<InvoiceBloc>(context)..add(ItemInputPageLaunch(invoice));
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
        appBar: Appbar().appbar(
            title: LatoText(''),
            onTap: () {
              onBackClick(context);
            }),
        body: SafeArea(
          child: SingleChildScrollView(
            child: isUserFound
                ? buildUserFoundScreen(screen)
                : buildUserNotFoundScreen(screen),
          ),
        ));
  }

  PrimaryContainer buildUserNotFoundScreen(Scale screen) {
    return PrimaryContainer(
      widget: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screen.horizontal(4), vertical: screen.vertical(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screen.vertical(50),
            ),
            Flexible(
              child: Container(
                height: screen.vertical(400),
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
                          'User with phone number ${widget.phoneNumber} not found !!',
                          size: 21,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screen.horizontal(4)),
                        child: CustomTextField(
                          hintText: "Customer Name",
                          keyboard: TextInputType.name,
                          textController: nameTextController,
                          textAlignment: TextAlign.start,
                          fillColor: Colour.bgColor,
                        ),
                      ),
                      SizedBox(
                        height: screen.vertical(40),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screen.horizontal(5)),
                        child: SubmitButton(
                          onPressed: () {
                            onContinueClick(context);
                          },
                          buttonName: 'Create Invoice',
                          buttonColor: Color(0xff355cfd),
                        ),
                      )
                    ],
                  ),
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
              onPressed: () {
                onContinueClick(context);
              },
              buttonName: 'Continue',
              buttonColor: Color(0xff355cfd),
            )
          ],
        ),
      ),
    );
  }
}
