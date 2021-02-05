import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/dialogs_sheet.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/pages/myQuotation.dart';
import 'package:locie/pages/store_bloc_view.dart';
import 'package:locie/views/Store_view/store_view.dart';
import 'package:locie/workers/sharing_wrokers.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SingleProductViewWidget extends StatefulWidget {
  final Listing listing;
  final bool isEditable;
  SingleProductViewWidget({this.isEditable = false, this.listing});
  @override
  _SingleProductViewWidgetState createState() =>
      _SingleProductViewWidgetState();
}

class _SingleProductViewWidgetState extends State<SingleProductViewWidget> {
  SharingWorkers sharingWorkers = SharingWorkers();
  LocalStorage localStorage = LocalStorage();
  void onShareClick() async {
    print('object');
    await sharingWorkers.shareListing(widget.listing);
  }

  void onEditClick() {}

  void onGoToStoreClick(BuildContext context) {
    // print('clicked');
    BlocProvider.of<NavigationBloc>(context).push(
        MaterialProviderRoute<StoreWidgetProvider>(
            route: StoreWidgetProvider(sid: widget.listing.store)));
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).pop();
  }

  Future<bool> doesStoreBelongToCurrentUser() async {
    await localStorage.init();
    return (localStorage.prefs.containsKey("sid") &&
        widget.listing.store == localStorage.prefs.getString("sid"));
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return true;
      },
      child: Scaffold(
        appBar: Appbar().appbar(
            title: LatoText(''),
            onTap: () {
              onBackClick(context);
            },
            actions: [
              if (widget.isEditable)
                IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: null)
            ]),
        body: PrimaryContainer(
          widget: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screen.horizontal(4),
                horizontal: screen.horizontal(8)),
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: screen.vertical(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LatoText(
                      widget.listing.name,
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        onShareClick();
                      },
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  height: screen.vertical(30),
                ),
                LatoText(
                  rupeeSign +
                      widget.listing.priceMax.toStringAsFixed(2) +
                      ' - ' +
                      rupeeSign +
                      widget.listing.priceMin.toStringAsFixed(2) +
                      ' per ' +
                      widget.listing.unit,
                  size: 16,
                  fontColor: Colors.amberAccent[700],
                ),
                SizedBox(
                  height: screen.vertical(20),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        onGoToStoreClick(context);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screen.horizontal(2),
                              vertical: screen.vertical(10)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colour.textfieldColor.withOpacity(0.65)),
                          child: Wrap(
                            children: [
                              Icon(
                                Icons.storefront,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(
                                width: screen.horizontal(3),
                              ),
                              LatoText(
                                "Go to Store",
                                weight: FontWeight.bold,
                                size: 18,
                              )
                            ],
                          )),
                    ),
                  ],
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
              builder: (context) => FutureBuilder<bool>(
                future: doesStoreBelongToCurrentUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return snapshot.data
                        ? QuotationDialoge(widget.listing)
                        : Center(
                            child: Container(
                              child: LatoText("You cannot quote"),
                            ),
                          );
                  }
                },
              ),
            );
          },
          backgroundColor: Colour.submitButtonColor,
          child: Icon(
            Icons.inventory,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
