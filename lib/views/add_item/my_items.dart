import 'package:flutter/material.dart';
import 'package:locie/bloc/listing_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/repo/listing_repo.dart';

class MyListingsWidget extends StatefulWidget {
  final ListingBloc bloc;
  List<Listing> listings;
  MyListingsWidget({this.bloc, this.listings = const []});

  @override
  _MyListingsWidgetState createState() => _MyListingsWidgetState();
}

class _MyListingsWidgetState extends State<MyListingsWidget> {
  ListingQuery listQuery = ListingQuery();
  List<Listing> listings = [];

  void initState() {
    listings = widget.listings;
    super.initState();
  }

  Future<void> removeListing(Listing listing, BuildContext context) async {
    showLoading();
    setState(() {
      listings.remove(listing);
    });
    await listQuery.removeListing(listing);
    Navigator.pop(context);
  }

  void onTap() {}

  void showLoading() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: PrimaryContainer(
                widget: Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Scaffold(
      appBar: Appbar().appbar(
          title: LatoText(
        'My Listings',
        size: 18,
        weight: FontWeight.bold,
      )),
      body: SafeArea(
          top: true,
          left: true,
          bottom: true,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: PrimaryContainer(
                widget: ListView.builder(
                  itemCount: widget.listings.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      onTap();
                    },
                    child: ListTile(
                      leading: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: scale.vertical(10)),
                          width: scale.horizontal(10),
                          child: RichImage(
                            image: listings[index].image,
                          )),
                      title: RailwayText(
                        widget.listings[index].name,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            removeListing(widget.listings[index], context);
                          }),
                    ),
                  ),
                ),
              ))),
    );
  }
}
