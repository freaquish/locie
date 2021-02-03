import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';

class InvoiceWidget extends StatefulWidget {
  @override
  _InvoiceWidgetState createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      // backgroundColor: Colour.bgColor,
      appBar: Appbar().appbar(
        title: LatoText(
          'Invoice',
          size: 22,
          weight: FontWeight.bold,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white), onPressed: () {})
        ],
      ),
      body: PrimaryContainer(
        widget: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screen.horizontal(4),
                  horizontal: screen.horizontal(6)),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.all(
                              Radius.circular(screen.horizontal(4)))),
                      tileColor: Colour.textfieldColor,
                      leading: Icon(
                        Icons.save,
                        color: Colors.red[400],
                      ),
                      title: RailwayText(
                        'Invoice Name',
                      ),
                      trailing: Icon(
                        Icons.south,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
