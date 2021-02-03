import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/invoice_dialogues.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/views/Invoice/taxes_discount.dart';

class InvoiceItemBilling extends StatefulWidget {
  Invoice invoice;
  InvoiceItemBilling(this.invoice);
  @override
  _InvoiceItemBillingState createState() => _InvoiceItemBillingState();
}

class _InvoiceItemBillingState extends State<InvoiceItemBilling> {
  List<Items> items = [];

  subTotal() {
    double total = 0.0;
    items.forEach((element) {
      total += element.total;
    });
    return total;
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<InvoiceBloc>(context)
      ..add(InvoiceCustomerPhoneInputPageLaunch());
  }

  // List items = [];
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(
          title: LatoText(''),
          onTap: () {
            onBackClick(context);
          }),
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
              onPressed: () {
                if (items.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => ModalDialogueBox(onPressed: (total) {
                      widget.invoice.subTotal = total;
                      BlocProvider.of<InvoiceBloc>(context)
                        ..add(FinanceInputPageLaunch(widget.invoice));
                    }),
                  );
                } else {
                  widget.invoice.items = items;
                  widget.invoice.subTotal = subTotal();
                  BlocProvider.of<InvoiceBloc>(context)
                    ..add(FinanceInputPageLaunch(widget.invoice));
                }
              },
              buttonName: 'Continue',
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
                              padding: EdgeInsets.only(
                                  left: screen.horizontal(6),
                                  top: screen.vertical(5)),
                              child: LatoText(items[i].name),
                            ),
                            title: Center(
                              child: LatoText('${items[i].quantity}'),
                            ),
                            trailing: Wrap(
                              spacing: screen.horizontal(3),
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screen.vertical(5)),
                                  child:
                                      LatoText('$rupeeSign ${items[i].total}'),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        right: screen.horizontal(2),
                                        top: screen.vertical(5)),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          items.removeAt(i);
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                    ))
                              ],
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
                      showDialog(
                        context: context,
                        builder: (context) => AddItemInvoiceDialogue(
                          onPressed: (item) {
                            setState(() {
                              items.add(item);
                            });
                            // Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    buttonName: 'Add Items',
                  ),
                ),
                SizedBox(
                  height: screen.vertical(30),
                ),
                Container(
                  height: screen.vertical(80),
                  width: screen.horizontal(100),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(screen.horizontal(3)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: screen.horizontal(3),
                            top: screen.vertical(5)),
                        child: LatoText(
                          'Sub Total',
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: screen.horizontal(3),
                            top: screen.vertical(5)),
                        child: LatoText(subTotal().toString()),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
