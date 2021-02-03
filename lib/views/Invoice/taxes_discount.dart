import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/dialogs_sheet.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/views/Invoice/invoice_item_billing.dart';

class TaxesAndDiscountWidget extends StatefulWidget {
  Invoice invoice;
  TaxesAndDiscountWidget({this.invoice});
  @override
  _TaxesAndDiscountWidgetState createState() => _TaxesAndDiscountWidgetState();
}

class _TaxesAndDiscountWidgetState extends State<TaxesAndDiscountWidget> {
  List<Taxes> taxes = [];

  @override
  void initState() {
    widget.invoice.grandTotal = widget.invoice.subTotal;
    super.initState();
  }

  void onBackClick(BuildContext context) {
    Invoice invoice = widget.invoice;
    invoice.taxes = null;
    invoice.amountPaid = null;
    invoice.discount = null;
    BlocProvider.of<InvoiceBloc>(context)..add(ItemInputPageLaunch(invoice));
  }

  void calculateGrandTotal() {
    double totalSum = widget.invoice.subTotal;
    if (widget.invoice.taxes != null) {
      widget.invoice.taxes.forEach((element) {
        totalSum += element.value;
      });
    }
    if (widget.invoice.discount != null) {
      widget.invoice.grandTotal -= widget.invoice.discount.value;
    }

    if (widget.invoice.amountPaid != null) {
      widget.invoice.grandTotal -= widget.invoice.amountPaid;
    }
    widget.invoice.grandTotal = totalSum;
  }

  void onNextClick(BuildContext context) {
    widget.invoice.taxes = taxes;
    calculateGrandTotal();
    BlocProvider.of<InvoiceBloc>(context)
      ..add(CreateInvoiceOnServer(widget.invoice));
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
                onNextClick(context);
              },
              buttonName: 'Create',
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
                          'Tax Name',
                          size: 18,
                        ),
                        LatoText(
                          'Factor',
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
                taxes.isEmpty
                    ? Container(
                        width: screen.horizontal(100),
                        color: Colors.black,
                        child: Center(
                          child: LatoText(
                            "Add taxes for billing (optional)",
                            size: 16,
                            fontColor: Colors.grey,
                          ),
                        ))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: taxes.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            tileColor: Colors.black,
                            leading: Padding(
                              padding: EdgeInsets.only(
                                  left: screen.horizontal(6),
                                  top: screen.vertical(5)),
                              child: LatoText(taxes[i].taxName),
                            ),
                            title: Center(
                              child: LatoText('${taxes[i].factor}%'),
                            ),
                            trailing: Wrap(
                              spacing: screen.horizontal(3),
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screen.vertical(5)),
                                  child: LatoText('${taxes[i].value}'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: screen.horizontal(2),
                                      top: screen.vertical(5)),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        var tax = taxes.removeAt(i);
                                        widget.invoice.grandTotal -= tax.value;
                                      });
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.redAccent,
                                      size: 18,
                                    ),
                                  ),
                                ),
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
                        builder: (context) => AddTaxDialog(
                          //TODO pass the value from bloc
                          subTotal: widget.invoice.subTotal,
                          onPressed: (item) {
                            setState(() {
                              taxes.add(item);
                              widget.invoice.grandTotal += item.value;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    buttonName: 'Add taxes',
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
                          'Discount',
                          size: 16,
                        ),
                      ),
                      Center(
                        //TODO pass invoice discount
                        child: LatoText(
                          widget.invoice.discount == null
                              ? ''
                              : widget.invoice.discount.factor.toString() + '%',
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: screen.horizontal(3),
                            top: screen.vertical(5)),
                        child: widget.invoice.discount == null
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: screen.horizontal(3),
                                    top: screen.vertical(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AddDiscountDialog(
                                        subTotal: widget.invoice.subTotal,
                                        onPressed: (discount) {
                                          setState(() {
                                            widget.invoice.discount = discount;
                                            widget.invoice.grandTotal -=
                                                discount.value;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colour.submitButtonColor,
                                  ),
                                ),
                              )
                            : LatoText(
                                '-$rupeeSign' +
                                    widget.invoice.discount.value.toString(),
                                size: 16,
                              ),
                      ),
                      if (widget.invoice.discount != null)
                        Padding(
                          padding: EdgeInsets.only(
                              right: screen.horizontal(3),
                              top: screen.vertical(5)),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.invoice.grandTotal +=
                                    widget.invoice.discount.value;
                                widget.invoice.discount = null;
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        )
                    ],
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
                          'Amount Received',
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: screen.horizontal(3),
                            top: screen.vertical(5)),
                        child: widget.invoice.amountPaid == null
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: screen.horizontal(3),
                                    top: screen.vertical(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AddReceivedDialog(
                                        paidAmount: widget.invoice.amountPaid,
                                        onPressed: (amountPaid) {
                                          setState(() {
                                            widget.invoice.amountPaid =
                                                amountPaid;
                                            widget.invoice.grandTotal -=
                                                amountPaid;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colour.submitButtonColor,
                                  ),
                                ),
                              )
                            : LatoText(
                                '-$rupeeSign' +
                                    widget.invoice.amountPaid.toString(),
                                size: 16,
                              ),
                      ),
                      if (widget.invoice.amountPaid != null)
                        Padding(
                          padding: EdgeInsets.only(
                              right: screen.horizontal(3),
                              top: screen.vertical(5)),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.invoice.grandTotal +=
                                    widget.invoice.amountPaid;
                                widget.invoice.amountPaid = null;
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        )
                    ],
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
                          'Grand Total',
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: screen.horizontal(3),
                            top: screen.vertical(5)),
                        //TODO insert grand total value;
                        child: LatoText(
                            '$rupeeSign ${widget.invoice.grandTotal.toStringAsFixed(2)}'),
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
