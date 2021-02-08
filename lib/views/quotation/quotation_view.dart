import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/dynamic_link_service.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/quotations.dart';
import 'package:locie/workers/worker_client.dart';

class QuotationCard extends StatefulWidget {
  final Quotation quotation;
  final bool isSent;
  QuotationCard(this.quotation, {this.isSent = false});

  @override
  _QuotationCardState createState() => _QuotationCardState();
}

class _QuotationCardState extends State<QuotationCard> {
  TextEditingController priceController;
  TextEditingController qunatityController;

  @override
  void dispose() {
    priceController.dispose();
    qunatityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    priceController =
        TextEditingController(text: widget.quotation.price.toStringAsFixed(2));
    qunatityController = TextEditingController(
        text: widget.quotation.quantity.toStringAsFixed(2));
    scale = Scale(context);
    super.initState();
  }

  String truncate(String text) {
    if (text.length > 28) {
      return text.substring(0, 28) + " ...";
    }
    return text;
  }

  Scale scale;

  void onReplyClick(BuildContext context) async {
    showReplyDialog(context);
  }

  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    scale = Scale(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: scale.vertical(5), horizontal: scale.horizontal(4)),
      margin: EdgeInsets.symmetric(vertical: scale.vertical(10)),
      decoration: BoxDecoration(
          color: Colour.textfieldColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: LatoText(
              widget.quotation.userName,
              size: 18,
            ),
            trailing: RailwayText(widget.quotation.timestamp.day.toString() +
                " " +
                months[widget.quotation.timestamp.month - 1] +
                " " +
                widget.quotation.timestamp.year.toString()),
          ),
          SizedBox(height: scale.vertical(2)),
          ListTile(
              leading: LatoText(
                truncate(widget.quotation.listingName),
                size: 18,
              ),
              title: Wrap(
                children: [
                  RailwayText(
                    rupeeSign +
                        widget.quotation.price.toStringAsFixed(2) +
                        "/ ${widget.quotation.listingUnit}",
                    fontColor: Colors.amberAccent[700],
                    size: 17,
                  ),
                  SizedBox(
                    width: scale.horizontal(4),
                  ),
                  RailwayText(
                    widget.quotation.quantity.toStringAsFixed(2),
                    size: 17,
                  ),
                ],
              )),
          if (!widget.isSent)
            SubmitButton(
                onPressed: () {
                  onReplyClick(context);
                },
                buttonName: "Reply",
                buttonColor: Color(0xff594694)),
          SizedBox(
            height: scale.vertical(10),
          )
        ],
      ),
    );
  }

  void sendMessage() async {
    if (priceController.text.isNotEmpty && qunatityController.text.isNotEmpty) {
      String text = widget.quotation.listingName +
          "is available at " +
          priceController.text +
          " " +
          widget.quotation.listingUnit +
          " for " +
          widget.quotation.quantity.toStringAsFixed(2) +
          " " +
          widget.quotation.listingUnit;
      text +=
          "\nPlease checkout ${DynamicLinksService.generateListingLink(widget.quotation.listing)}";
      await WorkerClient.sendMessage(widget.quotation.userContact, text);
      Navigator.of(context).pop();
    }
  }

  showReplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colour.bgColor,
        child: Container(
          height: scale.vertical(530),
          padding: EdgeInsets.symmetric(horizontal: scale.horizontal(4)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              SizedBox(
                height: scale.vertical(30),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: LatoText(
                  "Price",
                  size: 16,
                ),
              ),
              SizedBox(
                height: scale.vertical(15),
              ),
              CustomTextField(
                textAlignment: TextAlign.start,
                hintText: "Price",
                textController: priceController,
              ),
              SizedBox(
                height: scale.vertical(30),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: LatoText(
                  "Quantity",
                  size: 16,
                ),
              ),
              SizedBox(
                height: scale.vertical(15),
              ),
              CustomTextField(
                textAlignment: TextAlign.start,
                hintText: "Price",
                textController: priceController,
              ),
              SizedBox(
                height: scale.vertical(30),
              ),
              SubmitButton(
                  onPressed: () {
                    sendMessage();
                  },
                  buttonName: "Send",
                  buttonColor: Colour.submitButtonColor)
            ],
          ),
        ),
      ),
    );
  }
}
