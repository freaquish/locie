import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/components/units_dialog.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/quotations.dart';
import 'package:locie/models/unit.dart';
import 'package:locie/repo/listing_repo.dart';

class AddItemInvoiceDialogue extends StatefulWidget {
  final void Function(Items) onPressed;

  AddItemInvoiceDialogue({
    @required this.onPressed,
  });
  @override
  _AddItemInvoiceDialogueState createState() => _AddItemInvoiceDialogueState();
}

class _AddItemInvoiceDialogueState extends State<AddItemInvoiceDialogue> {
  TextEditingController textEditingControllerItemName = TextEditingController();
  TextEditingController textEditingControllerItemQuantity =
      TextEditingController();
  TextEditingController textEditingControllerItemPrice =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Unit> units = [];
  String unit = 'kg';
  bool isListLoaded = false;

  @override
  void dispose() {
    textEditingControllerItemName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            screen.horizontal(4),
          ),
        ),
      ),
      backgroundColor: Colour.bgColor,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screen.vertical(500),
          width: screen.horizontal(80),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screen.horizontal(4),
                vertical: screen.vertical(10)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LatoText(''),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  CustomTextField(
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      textAlignment: TextAlign.start,
                      hintText: 'Item Name',
                      textController: textEditingControllerItemName,
                      keyboard: TextInputType.name),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // spacing: screen.horizontal(10),
                    children: [
                      Container(
                        width: screen.horizontal(32),
                        child: CustomTextField(
                            validator: (value) {
                              if (value.isEmpty || value == null) {
                                return 'Required field';
                              }
                            },
                            textAlignment: TextAlign.start,
                            hintText: 'Price',
                            textController: textEditingControllerItemPrice,
                            keyboard: TextInputType.number),
                      ),
                      Container(
                        width: screen.horizontal(32),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    UnitDialog(onChange: (unitModel) {
                                      setState(() {
                                        this.unit = unitModel.sign;
                                      });
                                      Navigator.of(context).pop();
                                    }));
                          },
                          child: Container(
                            width: screen.horizontal(100),
                            // height: screen.vertical(80),
                            padding: EdgeInsets.symmetric(
                                vertical: screen.vertical(30),
                                horizontal: screen.horizontal(6)),
                            decoration: BoxDecoration(
                                color: Colour.textfieldColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screen.horizontal(4)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LatoText(
                                  unit,
                                  size: 18,
                                  weight: FontWeight.bold,
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  CustomTextField(
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      textAlignment: TextAlign.start,
                      hintText: 'Quantity',
                      textController: textEditingControllerItemQuantity,
                      keyboard: TextInputType.number),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SubmitButton(
                      onPressed: () {
                        String name = textEditingControllerItemName.text;

                        if (_formKey.currentState.validate()) {
                          Items item = Items(
                              name: name,
                              price: double.parse(
                                  textEditingControllerItemPrice.text),
                              quantity: double.parse(
                                  textEditingControllerItemQuantity.text),
                              unit: unit);
                          widget.onPressed(item);
                          textEditingControllerItemName.clear();
                          textEditingControllerItemPrice.clear();
                          textEditingControllerItemQuantity.clear();
                        }
                      },
                      buttonName: 'Add',
                      buttonColor: Colour.submitButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModalDialogueBox extends StatefulWidget {
  final void Function(dynamic subtotal) onPressed;
  ModalDialogueBox({@required this.onPressed});
  @override
  _ModalDialogueBoxState createState() => _ModalDialogueBoxState();
}

class _ModalDialogueBoxState extends State<ModalDialogueBox> {
  TextEditingController textEditingControllerSubTotal = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            screen.horizontal(4),
          ),
        ),
      ),
      backgroundColor: Colour.bgColor,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screen.vertical(250),
          width: screen.horizontal(80),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(4),
              vertical: screen.vertical(20),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  CustomTextField(
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      textAlignment: TextAlign.start,
                      hintText: 'Sub Total',
                      textController: textEditingControllerSubTotal,
                      keyboard: TextInputType.number),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.onPressed(textEditingControllerSubTotal.text);
                        }
                      },
                      buttonName: 'Add',
                      buttonColor: Colour.submitButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddTaxDialog extends StatefulWidget {
  final double subTotal;
  final void Function(Taxes) onPressed;
  AddTaxDialog({@required this.onPressed, this.subTotal});
  @override
  _AddTaxDialogState createState() => _AddTaxDialogState();
}

class _AddTaxDialogState extends State<AddTaxDialog> {
  TextEditingController textEditingControllerTaxName = TextEditingController();
  TextEditingController textEditingControllerFactor = TextEditingController();
  TextEditingController textEditingControllerValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String percentage = '0.0';

  percentageValue() {
    double value = double.parse(percentage) / 100 * widget.subTotal;
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            screen.horizontal(4),
          ),
        ),
      ),
      backgroundColor: Colour.bgColor,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screen.vertical(500),
          width: screen.horizontal(80),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screen.horizontal(4),
                vertical: screen.vertical(10)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LatoText(''),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  CustomTextField(
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                      },
                      textAlignment: TextAlign.start,
                      hintText: 'Tax Name',
                      textController: textEditingControllerTaxName,
                      keyboard: TextInputType.name),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Container(
                    width: screen.horizontal(32),
                    child: CustomTextField(
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                        },
                        textAlignment: TextAlign.start,
                        hintText: 'Percentage',
                        textController: textEditingControllerFactor,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              percentage = value.toString().trim();
                            });
                          } else {
                            setState(() {
                              percentage = "0.0";
                            });
                          }
                          percentageValue();
                        },
                        keyboard: TextInputType.number),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Container(
                    width: screen.horizontal(32),
                    height: screen.vertical(75),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screen.horizontal(3),
                          vertical: screen.vertical(20)),
                      child: LatoText(
                          widget.subTotal == null ? '0.0' : percentageValue()),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          screen.horizontal(3),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          String name = textEditingControllerTaxName.text;
                          Taxes taxes = Taxes(
                              factor: double.parse(
                                  textEditingControllerFactor.text),
                              taxName: name.toUpperCase(),
                              value: double.parse(percentageValue()));
                          widget.onPressed(taxes);
                          textEditingControllerFactor.clear();
                          textEditingControllerTaxName.clear();
                          setState(() {
                            percentage = '0.0';
                          });
                        }
                      },
                      buttonName: 'Add',
                      buttonColor: Colour.submitButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDiscountDialog extends StatefulWidget {
  final double subTotal;
  final void Function(Discount) onPressed;
  AddDiscountDialog({@required this.onPressed, this.subTotal});
  @override
  _AddDiscountDialogState createState() => _AddDiscountDialogState();
}

class _AddDiscountDialogState extends State<AddDiscountDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerFactor = TextEditingController();
  String percentage = '0.0';

  percentageValue() {
    double value = double.parse(percentage) / 100 * widget.subTotal;
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            screen.horizontal(4),
          ),
        ),
      ),
      backgroundColor: Colour.bgColor,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screen.vertical(400),
          width: screen.horizontal(80),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screen.horizontal(4),
                vertical: screen.vertical(10)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LatoText(''),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Container(
                    width: screen.horizontal(32),
                    child: CustomTextField(
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                        },
                        textAlignment: TextAlign.start,
                        hintText: 'Percentage',
                        textController: textEditingControllerFactor,
                        onChanged: (value) {
                          //(widget.subTotal);
                          if (value.isNotEmpty) {
                            setState(() {
                              percentage = value.toString().trim();
                            });
                          } else {
                            setState(() {
                              percentage = "0.0";
                            });
                          }
                          percentageValue();
                        },
                        keyboard: TextInputType.number),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Container(
                    width: screen.horizontal(32),
                    height: screen.vertical(75),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screen.horizontal(3),
                          vertical: screen.vertical(20)),
                      child: LatoText(
                          widget.subTotal == null ? '0.0' : percentageValue()),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          screen.horizontal(3),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Discount discount = Discount(
                              factor: double.parse(
                                  textEditingControllerFactor.text),
                              value: double.parse(percentageValue()));
                          widget.onPressed(discount);
                        }
                      },
                      buttonName: 'Add',
                      buttonColor: Colour.submitButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddReceivedDialog extends StatefulWidget {
  final double paidAmount;
  final void Function(double) onPressed;
  AddReceivedDialog({@required this.onPressed, this.paidAmount});
  @override
  _AddReceivedDialogState createState() => _AddReceivedDialogState();
}

class _AddReceivedDialogState extends State<AddReceivedDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerFactor = TextEditingController();
  String percentage = '0.0';

  double amountPaid;

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            screen.horizontal(4),
          ),
        ),
      ),
      backgroundColor: Colour.bgColor,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screen.vertical(300),
          width: screen.horizontal(80),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screen.horizontal(4),
                vertical: screen.vertical(10)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LatoText(''),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  Container(
                    width: screen.horizontal(32),
                    child: CustomTextField(
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                        },
                        textAlignment: TextAlign.start,
                        hintText: 'Amount Paid',
                        textController: textEditingControllerFactor,
                        keyboard: TextInputType.number),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          amountPaid = double.parse(
                              textEditingControllerFactor.text.trim());
                          double paidAmount = amountPaid;
                          widget.onPressed(paidAmount);
                        }
                      },
                      buttonName: 'Add',
                      buttonColor: Colour.submitButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuotationDialoge extends StatefulWidget {
  final Listing listing;
  QuotationDialoge(this.listing);
  @override
  _QuotationDialogeState createState() => _QuotationDialogeState();
}

class _QuotationDialogeState extends State<QuotationDialoge> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerPrice = TextEditingController();
  TextEditingController textEditingControllerQuantity = TextEditingController();
  ListingQuery query = ListingQuery();

  bool isUploadingQuotation = false;

  void onClickNext(BuildContext context) async {
    setState(() {
      isUploadingQuotation = true;
    });
    Quotation quotation = Quotation(
      store: widget.listing.store,
      listing: widget.listing.id,
      listingName: widget.listing.name,
      listingUnit: widget.listing.unit,
      storeName: widget.listing.storeName,
      price: double.parse(textEditingControllerPrice.text),
      quantity: double.parse(textEditingControllerQuantity.text),
    );
    await query.createQuotation(quotation);
    setState(() {
      isUploadingQuotation = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              screen.horizontal(4),
            ),
          ),
        ),
        backgroundColor: Colour.bgColor,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: (isUploadingQuotation)
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: screen.vertical(400),
                  width: screen.horizontal(80),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontal(4),
                        vertical: screen.vertical(10)),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          SizedBox(
                            height: screen.vertical(20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LatoText(''),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: screen.vertical(20),
                          ),
                          Container(
                            width: screen.horizontal(32),
                            child: CustomTextField(
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return 'Required field';
                                  }
                                },
                                textAlignment: TextAlign.start,
                                hintText: 'Price',
                                textController: textEditingControllerPrice,
                                keyboard: TextInputType.number),
                          ),
                          SizedBox(
                            height: screen.vertical(20),
                          ),
                          Container(
                            width: screen.horizontal(32),
                            child: CustomTextField(
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return 'Required field';
                                  }
                                },
                                textAlignment: TextAlign.start,
                                hintText: 'Quantity',
                                textController: textEditingControllerQuantity,
                                keyboard: TextInputType.number),
                          ),
                          SizedBox(
                            height: screen.vertical(20),
                          ),
                          SubmitButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  debugPrint('Done');
                                  onClickNext(context);
                                }
                              },
                              buttonName: 'Add',
                              buttonColor: Colour.submitButtonColor)
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
