import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/views/Store_view/about_store.dart';

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
              ),
            ),
            Positioned(
              top: screen.vertical(10),
              left: screen.vertical(10),
              child: IconButton(
                color: Colors.white,
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
                  padding: EdgeInsets.only(
                      top: screen.vertical(0),
                      left: screen.horizontal(6),
                      right: screen.horizontal(6)),
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
                    controller: scrollController,
                    children: [
                      TabBar(
                        tabs: [
                          LatoText("About"),
                          LatoText("About"),
                          LatoText("About"),
                          LatoText("About"),
                        ],
                        controller: tabController,
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
