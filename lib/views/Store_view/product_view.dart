import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/dialogs_sheet.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';

class SingleProductViewWidget extends StatefulWidget {
  final Listing listing;
  final bool isEditable;
  SingleProductViewWidget({this.isEditable = false, this.listing});
  @override
  _SingleProductViewWidgetState createState() =>
      _SingleProductViewWidgetState();
}

class _SingleProductViewWidgetState extends State<SingleProductViewWidget> {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(
        title: LatoText(''),
      ),
      body: PrimaryContainer(
        widget: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screen.horizontal(4), horizontal: screen.horizontal(8)),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: screen.vertical(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LatoText(
                    widget.listing.name,
                    size: 28,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: screen.vertical(10)),
              LatoText(
                widget.listing.storeName,
                size: 16,
              ),
              SizedBox(
                height: screen.vertical(30),
              ),
              Container(
                height: screen.vertical(400),
                width: screen.horizontal(100),
                child: RichImage(
                  image: widget.listing.image,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                height: screen.vertical(10),
              ),
              LatoText(
                rupeeSign +
                    widget.listing.priceMax.toString() +
                    '- ' +
                    rupeeSign +
                    widget.listing.priceMin.toString() +
                    'per' +
                    widget.listing.unit,
                size: 16,
                fontColor: Colors.amberAccent[700],
              ),
              SizedBox(
                height: screen.vertical(20),
              ),
              RailwayText(
                widget.listing.description,
                size: 16,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => QuotationDialoge(),
          );
        },
        backgroundColor: Colour.submitButtonColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}
