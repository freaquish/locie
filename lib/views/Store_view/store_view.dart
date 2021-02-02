import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/views/Store_view/about_store.dart';
import 'package:locie/views/Store_view/product.dart';
import 'package:locie/views/Store_view/reviews.dart';
import 'package:locie/views/Store_view/work.dart';

class StoreViewWidget extends StatefulWidget {
  @override
  _StoreViewWidgetState createState() => _StoreViewWidgetState();
}

class _StoreViewWidgetState extends State<StoreViewWidget>
    with TickerProviderStateMixin {
  String imageUrl;

  TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    tabController.addListener(handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  handleTabSelection() {
    setState(() {});
  }

  Widget getCurrentBodyWidget() {
    List<Widget> widgets = [
      StoreAboutWidget(),
      StoreProductWidget(),
      StoreWorksWidget(),
      StoreReviewsWidget()
    ];
    return widgets[tabController.index];
  }

  PageController pageController = PageController();
  // TabController tabController = TabController(length: 4, vsync: null)

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return SafeArea(
      child: PrimaryContainer(
        widget: Stack(
          children: [
            Container(
              height: screen.vertical(420),
              width: screen.horizontal(100),
              decoration: BoxDecoration(
                  color: Colour.skeletonColor,
                  image: DecorationImage(
                    image: AssetImage('assets/images/placeholder.png'),
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              top: screen.vertical(10),
              left: screen.vertical(10),
              child: IconButton(
                color: Colors.grey,
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () {},
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 1 - 0.38,
              minChildSize: 1 - 0.38,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colour.bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        screen.horizontal(8),
                      ),
                      topRight: Radius.circular(
                        screen.horizontal(8),
                      ),
                    ),
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screen.horizontal(2),
                            screen.vertical(50),
                            screen.horizontal(2),
                            screen.vertical(30)),
                        child: TabBar(
                          indicatorColor: Colors.white,
                          indicator: UnderlineTabIndicator(
                              insets: EdgeInsets.only(
                            left: screen.horizontal(2),
                            right: screen.horizontal(2),
                          )),
                          tabs: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screen.horizontal(2)),
                              child: LatoText(
                                'About',
                                fontColor: tabController.index == 0
                                    ? Colors.white
                                    : Color(0xff6c6c6c),
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screen.horizontal(2)),
                              child: LatoText('Product',
                                  fontColor: tabController.index == 1
                                      ? Colors.white
                                      : Color(0xff6c6c6c),
                                  size: 16),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screen.horizontal(2)),
                              child: LatoText('Work',
                                  fontColor: tabController.index == 2
                                      ? Colors.white
                                      : Color(0xff6c6c6c),
                                  size: 16),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screen.horizontal(2)),
                              child: LatoText('Review',
                                  fontColor: tabController.index == 3
                                      ? Colors.white
                                      : Color(0xff6c6c6c),
                                  size: 16),
                            ),
                          ],
                          controller: tabController,
                        ),
                      ),
                      getCurrentBodyWidget()
                    ],
                  ),
                );
              },
            ),
            //
          ],
        ),
      ),
    );
  }
}
