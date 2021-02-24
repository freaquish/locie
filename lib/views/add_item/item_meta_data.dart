import 'package:flutter/material.dart';
import 'package:locie/bloc/listing_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/switch_button.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/components/units_dialog.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/unit.dart';

class ItemMetaDataWidget extends StatefulWidget {
  final ListingBloc bloc;
  Listing listing;
  ItemMetaDataWidget({this.bloc, this.listing});
  @override
  _ItemMetaDataWidgetState createState() => _ItemMetaDataWidgetState();
}

class _ItemMetaDataWidgetState extends State<ItemMetaDataWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerMax = TextEditingController();
  TextEditingController textEditingControllerMin = TextEditingController();
  List<Unit> units = [];
  String unit = 'kg';
  bool inStockSwitch = true;
  bool isListLoaded = false;

  @override
  void initState() {
    //(widget.listing.priceMax);
    if (widget.listing.priceMax != null) {
      textEditingControllerMax.value =
          TextEditingValue(text: widget.listing.priceMax.toString());
      textEditingControllerMin.value =
          TextEditingValue(text: widget.listing.priceMin.toString());
      unit = widget.listing.unit;
      inStockSwitch = widget.listing.inStock;
    }
    super.initState();
  }

  void onBackClick() {
    widget.bloc
      ..add(InitiateListingCreation(
          category: widget.listing.category, listing: widget.listing));
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colour.bgColor,
        appBar: Appbar().appbar(
          context: context,
          onTap: () {
            onBackClick();
          },
          title: LatoText(
            '',
            size: 22,
            weight: FontWeight.bold,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: PrimaryContainer(
              widget: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screen.horizontal(4),
                    horizontal: screen.horizontal(6)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screen.vertical(60),
                      ),
                      RailwayText(
                        'Price',
                        size: 32,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: screen.vertical(50),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screen.horizontal(40),
                              child: CustomTextField(
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return 'Required field';
                                    }
                                  },
                                  textAlignment: TextAlign.start,
                                  hintText: 'Max',
                                  maxLines: 3,
                                  minLines: 2,
                                  textController: textEditingControllerMax,
                                  keyboard: TextInputType.number),
                            ),
                            Container(
                              width: screen.horizontal(40),
                              child: CustomTextField(
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return 'Required field';
                                    }
                                  },
                                  textAlignment: TextAlign.start,
                                  hintText: 'Min',
                                  maxLines: 3,
                                  minLines: 2,
                                  textController: textEditingControllerMin,
                                  keyboard: TextInputType.number),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screen.vertical(50),
                      ),
                      Container(
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
                            child: LatoText(
                              unit,
                              size: 18,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screen.vertical(50),
                      ),
                      Container(
                        height: screen.vertical(50),
                        width: screen.horizontal(100),
                        decoration: BoxDecoration(
                            color: Colour.bgColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(screen.horizontal(4)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: screen.horizontal(3.5)),
                              child: LatoText(
                                'Item in Stock',
                                size: 20,
                                fontColor: Colors.grey[200],
                                weight: FontWeight.normal,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screen.horizontal(2.5)),
                              child: CustomSwitch(
                                value: inStockSwitch,
                                onChanged: (bool val) {
                                  setState(() {
                                    inStockSwitch = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screen.vertical(270),
                      ),
                      SubmitButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            debugPrint('submit');
                            widget.listing.priceMax = double.parse(
                                textEditingControllerMax.value.text);
                            widget.listing.priceMin = double.parse(
                                textEditingControllerMin.value.text);
                            widget.listing.unit = unit;
                            widget.listing.inStock = inStockSwitch;
                            widget.bloc..add(CreateListing(widget.listing));
                          }
                        },
                        buttonName: 'Done',
                        buttonColor: Colour.submitButtonColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
