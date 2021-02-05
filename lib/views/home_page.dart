import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/search/listing_card.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageView extends StatefulWidget {
  final bool isStoreExists;
  HomePageView({this.isStoreExists = false});
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int currentTabIndex = 1;

  void onTabTap(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
      bottomNavigationBar: Container(
        color: Colour.skeletonColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(4), vertical: screen.vertical(15)),
          child: Container(
            color: Colour.skeletonColor,
            height: screen.vertical(60),
            width: screen.horizontal(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/Home_Icon.svg',
                    height: screen.vertical(30),
                    width: screen.horizontal(4),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  splashRadius: 1,
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: screen.horizontal(6),
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  splashRadius: 1,
                  icon: Icon(
                    Icons.article_outlined,
                    size: screen.horizontal(6),
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // print('safe area is tapped');
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
            child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screen.horizontal(8),
                  right: screen.horizontal(8),
                  top: screen.vertical(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: screen.vertical(30),
                      width: screen.horizontal(8),
                      color: Colour.bgColor,
                      child: Image.asset('assets/images/menu.png'),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(50),
                  ),
                  CustomTextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    textAlignment: TextAlign.start,
                    hintText: 'Search',
                    preffixWidget: Container(
                      height: screen.vertical(5),
                      width: screen.horizontal(2),
                      color: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(screen.horizontal(3.5)),
                        child: Image.asset('assets/images/SearchIcon.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  if (searchText.isNotEmpty)
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            onTabTap(0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screen.horizontal(6),
                                vertical: screen.vertical(20)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: currentTabIndex == 0 ? 2 : 0,
                                        color: Colors.white))),
                            child: LatoText("Items",
                                fontColor: Colors.white,
                                weight: currentTabIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            onTabTap(1);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screen.horizontal(6),
                                vertical: screen.vertical(20)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: currentTabIndex == 1 ? 2 : 0,
                                        color: Colors.white))),
                            child: LatoText("Stores",
                                fontColor: Colors.white,
                                weight: currentTabIndex == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  SizedBox(
                    height: screen.vertical(50),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // print('Tapped');
                        },
                        child: ListingCard(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
