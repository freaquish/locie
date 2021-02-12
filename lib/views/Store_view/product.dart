import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';

class StoreProductWidget extends StatefulWidget {
  final List<Listing> listings;
  final List<Category> categories;
  final String sid;
  final String current;
  StoreProductWidget(this.listings,
      {this.categories = const [], this.sid, this.current});

  @override
  _StoreProductWidgetState createState() => _StoreProductWidgetState();
}

class _StoreProductWidgetState extends State<StoreProductWidget> {
  String placeHolder = 'assets/images/item_placeholder.png';

  // List<dynamic> completeList = [];

  ImageProvider getProvider(Listing listing) {
    if (listing.image == null || listing.image.isEmpty) {
      return AssetImage(placeHolder);
    } else {
      return NetworkImage(listing.image);
    }
  }

  void onItemClick(BuildContext context, String lid) {
    //(lid);
    BlocProvider.of<NavigationBloc>(context).push(LaunchItemView(lid));
  }

  dynamic getElementFromCompsitieList(int index) {
    if (index < widget.categories.length) {
      return widget.categories[index];
    } else if (index - widget.categories.length < widget.listings.length) {
      return widget.listings[index - widget.categories.length];
    }
  }

  ScrollController _scrollController;
  ScrollPhysics physics = NeverScrollableScrollPhysics();

  @override
  void initState() {
    // completeList = widget.listings.map((e) => e as dynamic).toList()
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  void _handleScroll() {
    setState(() {});
  }

  void onClick(BuildContext context, dynamic element) {
    if (element is Category) {
      onCategoryClick(context, element as Category);
    } else {
      {
        onItemClick(context, element.id);
      }
    }
  }

  void onCategoryClick(BuildContext context, Category category) {
    BlocProvider.of<StoreViewBloc>(context)
      ..add(FetchStoreProducts(widget.sid, parent: category.id));
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
          itemCount: widget.listings.length + widget.categories.length,
          itemBuilder: (context, index) {
            var element = getElementFromCompsitieList(index);
            bool isCategory = element is Category;
            Key key = Key(element.id);
            return GestureDetector(
              key: key,
              onTap: () {
                onClick(context, element);
                // onItemClick(context, widget.listings[index].id);
              },
              child: Container(
                key: key,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        key: key,
                        width: screen.horizontal(50),
                        height: screen.vertical(390),
                        child: RichImage(
                          image: element.image,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    ListTile(
                        title: RailwayText(
                          element.name,
                          key: key,
                        ),
                        subtitle: isCategory
                            ? null
                            : LatoText(
                                '$rupeeSign ${element.priceMax} - $rupeeSign ${element.priceMin}',
                                fontColor: Color(0xffFF7A00),
                                key: key,
                                size: 12,
                              )),
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
