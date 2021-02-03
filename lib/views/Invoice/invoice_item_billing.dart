import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';

class InvoiceItemBilling extends StatefulWidget {
  @override
  _InvoiceItemBillingState createState() => _InvoiceItemBillingState();
}

class _InvoiceItemBillingState extends State<InvoiceItemBilling> {
  // List<Items> items = [];
  List items = [];
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(
        title: LatoText(''),
      ),
      bottomNavigationBar: Container(
        color: Colour.bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(4), vertical: screen.vertical(15)),
          child: Container(
            color: Colour.bgColor,
            height: screen.vertical(100),
            width: screen.horizontal(100),
            child: SubmitButton(
              onPressed: () {},
              buttonName: 'Create Invoice',
              buttonColor: Color(0xff355cfd),
            ),
          ),
        ),
      ),
      body: PrimaryContainer(
        widget: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(4), vertical: screen.horizontal(1)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screen.vertical(10),
                ),
                Container(
                  width: screen.horizontal(100),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screen.horizontal(4)),
                        topRight: Radius.circular(screen.horizontal(4)),
                      )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontal(3),
                        vertical: screen.vertical(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LatoText(
                          'Item',
                          size: 18,
                        ),
                        LatoText(
                          'Quantity',
                          size: 18,
                        ),
                        LatoText(
                          'Amount',
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                items.isEmpty
                    ? Container(
                        width: screen.horizontal(100),
                        color: Colors.black,
                        child: Center(
                          child: LatoText(
                            "Add Items for billing (optional)",
                            size: 16,
                            fontColor: Colors.grey,
                          ),
                        ))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            tileColor: Colors.black,
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LatoText(items[i]),
                            ),
                          );
                        },
                      ),
                Container(
                  width: screen.horizontal(100),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screen.horizontal(4)),
                      bottomRight: Radius.circular(screen.horizontal(4)),
                    ),
                  ),
                  child: Text(''),
                ),
                SizedBox(
                  height: screen.vertical(20),
                ),
                Container(
                  height: screen.vertical(70),
                  width: screen.horizontal(35),
                  child: SubmitButton(
                    buttonColor: Colour.submitButtonColor,
                    onPressed: () {
                      setState(() {
                        items.add('Lawde');
                      });
                    },
                    buttonName: 'Add Items',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
