import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';

class StoreProductWidget extends StatefulWidget {
  final List<Listing> listings;
  StoreProductWidget(this.listings);

  @override
  _StoreProductWidgetState createState() => _StoreProductWidgetState();
}

class _StoreProductWidgetState extends State<StoreProductWidget> {
  String placeHolder = 'assets/images/item_placeholder.png';

  ImageProvider getProvider(Listing listing) {
    if (listing.image == null || listing.image.isEmpty) {
      return AssetImage(placeHolder);
    } else {
      return NetworkImage(listing.image);
    }
  }

  void onItemClick(BuildContext context, String lid) {
    print(lid);
    BlocProvider.of<NavigationBloc>(context).push(LaunchItemView(lid));
  }

  ScrollController _scrollController;
  ScrollPhysics physics = NeverScrollableScrollPhysics();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  void _handleScroll() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screen.horizontal(6), vertical: screen.vertical(5)),
      child: Container(
        padding: EdgeInsets.only(bottom: screen.vertical(50)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: screen.horizontal(50) / screen.vertical(470),
              crossAxisCount: 2),
          physics: BouncingScrollPhysics(),
          // controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.listings.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onItemClick(context, widget.listings[index].id);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        key: Key(widget.listings[index].id),
                        width: screen.horizontal(50),
                        height: screen.vertical(390),
                        child: RichImage(
                          image: widget.listings[index].image,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    Padding(
                      key: Key(widget.listings[index].id),
                      padding: EdgeInsets.symmetric(
                          horizontal: screen.horizontal(3),
                          vertical: screen.vertical(10)),
                      child: RailwayText(
                        widget.listings[index].name,
                        key: Key(widget.listings[index].id),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screen.horizontal(3)),
                      child: LatoText(
                        '$rupeeSign ${widget.listings[index].priceMax} - $rupeeSign ${widget.listings[index].priceMin}',
                        fontColor: Color(0xffFF7A00),
                        key: Key(widget.listings[index].id),
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
