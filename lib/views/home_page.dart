import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/components/search/listing_card.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';

class HomePageView extends StatefulWidget {
  final bool isStoreExists;
  HomePageView({this.isStoreExists = false});
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocalStorage localStorage = LocalStorage();
  Store store;
  Account account;

  int currentTabIndex = 1;

  Future<void> getStoreAndAccount() async {
    await localStorage.init();
    account = await localStorage.getAccount();
    if (localStorage.prefs.containsKey("sid")) {
      store = await localStorage.getStore();
    }
    setState(() {});
  }

  @override
  void initState() {
    getStoreAndAccount();
    super.initState();
  }

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
      key: _scaffoldKey,
      backgroundColor: Colour.bgColor,
      endDrawerEnableOpenDragGesture: false,
      drawer: NavigationDrawer(
        isStoreExists: widget.isStoreExists,
        scaffoldKey: _scaffoldKey,
        account: account,
      ),
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
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
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

class NavigationDrawer extends StatelessWidget {
  final bool isStoreExists;
  final GlobalKey scaffoldKey;
  final Account account;
  NavigationDrawer(
      {this.isStoreExists = false, this.scaffoldKey, this.account});

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Drawer(
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: scale.vertical(40), horizontal: scale.horizontal(4)),
          color: Colour.bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: scale.vertical(20)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colour.textfieldColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      child: Container(
                        // alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(account.avatar),
                          radius: scale.horizontal(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: scale.vertical(30),
                    ),
                    Container(
                      child: Container(
                        // alignment: Alignment.center,
                        child: LatoText(
                          account.name,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: scale.vertical(30),
              ),
              if (isStoreExists)
                InkWell(
                  child: ListTile(
                    leading: Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: LatoText("Store", size: 18),
                  ),
                )
            ],
          )),
    );
  }
}
