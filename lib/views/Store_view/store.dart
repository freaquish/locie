import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';
import 'package:locie/pages/store_bloc_view.dart';
import 'package:locie/repo/store_view_repo.dart';

import '../../singleton.dart';

class StoreViewWidget extends StatefulWidget {
  final String sid;
  final StoreViewEvent event;
  final Store store;
  StoreViewWidget({this.sid, this.event, this.store});
  @override
  _StoreViewWidgetState createState() => _StoreViewWidgetState();
}

class _StoreViewWidgetState extends State<StoreViewWidget>
    with TickerProviderStateMixin {
  String imageUrl;

  TextEditingController textEditingControllerReview = TextEditingController();
  double rating = 0;

  TabController tabController;

  StoreViewGlobalStateSingleton singleton;
  StoreViewBloc bloc;
  StoreViewEvent event;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    singleton = StoreViewGlobalStateSingleton();
    bloc = StoreViewBloc();
    if (widget.event == null) {
      event = FetchStoreView(widget.store);
    }
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    tabController.addListener(handleTabSelection);
    // _scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    print(_scrollController.position.pixels);
    if (_scrollController.position.atEdge &&
        tabController.index % 2 != 0 &&
        _scrollController.position.pixels != 0) {
      // As Products and Reviews are on 1 and 3
      // bloc..add(getEvent());
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    textEditingControllerReview.dispose();
    super.dispose();
  }

  handleTabSelection() {
    setState(() {
      event = getEvent();
      debugPrint('$event, ${tabController.index}');
      bloc..add(event);
    });
    // bloc..add(event);
  }

  StoreViewEvent getEvent() {
    if (tabController.index == 0) {
      // About tab; if store is null then fetch event otherwise InjectEvent
      if (!singleton.isStoreNull) {
        return InjectStoreView(FetchedStore(singleton.store));
      } else {
        return FetchStoreView(widget.store);
      }
    } else if (tabController.index == 1) {
      // Product tab; if listing is empty then send FetchProduct with startAt
      /// else set startAt = listings[length-1].snapshot [limit=10]
      /// the state will start loading if listings.length > 0  then tell widget to show extent loading else full screen
      if (singleton.isListingNull) {
        return FetchStoreProducts(widget.sid);
      } else if (singleton.isNextListingFetchViable) {
        return FetchStoreProducts(widget.sid,
            startAt: singleton.lastListingSnap);
      }
    } else if (tabController.index == 2) {
      if (singleton.isExamplesNull) {
        return FetchStoreWorks(widget.sid);
      } else {
        return InjectStoreView(FetchedStoreWorks(singleton.examples));
      }
    } else if (tabController.index == 3) {
      // Reviews tab; if reviews is null then fetch without startA
      /// if Reviews is notEmpty and length is [limit=5] then fetch Next
      if (singleton.isReviewNull) {
        return FetchStoreReviews(widget.sid);
      } else if (singleton.isNextReviewFetchViable) {
        return FetchStoreReviews(widget.sid, startAt: singleton.lastReviewSnap);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colour.submitButtonColor,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          showBottomReviewSheet(context, screen);
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: screen.vertical(420),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: LatoText('Store'),
                background:
                    widget.store.image != null || widget.store.image != ''
                        ? Image.network(widget.store.image)
                        : Image.asset('assets/images/store_placeholder.png'),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: tabController,
                  indicatorColor: Colors.white,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screen.horizontal(2)),
                      child: LatoText(
                        'About',
                        fontColor: tabController.index == 0
                            ? Colors.white
                            : Color(0xff6c6c6c),
                        size: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screen.horizontal(2)),
                      child: LatoText('Product',
                          fontColor: tabController.index == 1
                              ? Colors.white
                              : Color(0xff6c6c6c),
                          size: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screen.horizontal(2)),
                      child: LatoText('Work',
                          fontColor: tabController.index == 2
                              ? Colors.white
                              : Color(0xff6c6c6c),
                          size: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screen.horizontal(2)),
                      child: LatoText('Review',
                          fontColor: tabController.index == 3
                              ? Colors.white
                              : Color(0xff6c6c6c),
                          size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: StoreViewProvider(
          event,
          singleton: singleton,
          bloc: bloc,
        ),
      ),
    );
  }

  Future<void> callCreateReviewApi(BuildContext context) async {
    Store store = singleton.store;
    Account account = await LocalStorage().getAccount();
    Review review = Review(
      rating: rating,
      store: store.id,
      text: textEditingControllerReview.text,
      user: account.uid,
      userImage: account.avatar,
      userName: account.name,
    );
    StoreViewRepo().createReview(review);
    Navigator.of(context).pop();
  }

  showBottomReviewSheet(BuildContext parentContext, Scale screen) {
    return showDialog(
      context: parentContext,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colour.bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: screen.vertical(20)),
            decoration: new BoxDecoration(
                color: Colour.bgColor,
                borderRadius: new BorderRadius.circular(16)),
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(screen.horizontal(3)),
                  child: Text(
                    'Please share your experience with us',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Mulish'),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screen.horizontal(4)),
                  child: RatingBar.builder(
                    initialRating: 0,
                    itemCount: 5,
                    unratedColor: Colors.grey,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                      }
                    },
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rating = rating;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: screen.vertical(50),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screen.horizontal(4)),
                  child: CustomTextField(
                      textAlignment: TextAlign.start,
                      hintText: 'Review',
                      textController: textEditingControllerReview,
                      keyboard: TextInputType.multiline),
                ),
                SizedBox(
                  height: screen.vertical(30),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screen.horizontal(4)),
                  child: SubmitButton(
                    buttonColor: Colour.submitButtonColor,
                    buttonName: 'Post',
                    onPressed: () {
                      if (textEditingControllerReview.text.isNotEmpty ||
                          rating > 0) {
                        callCreateReviewApi(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
