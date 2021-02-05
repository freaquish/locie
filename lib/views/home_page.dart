import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/search_bloc.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/bloc/store_view_bloc.dart';
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
import 'package:locie/pages/search_view.dart';
import 'package:locie/pages/store_bloc_view.dart';

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
  String searchText = '';

  Future<void> getStoreAndAccount() async {
    await localStorage.init();
    account = await localStorage.getAccount();
    if (localStorage.prefs.containsKey("sid")) {
      store = await localStorage.getStore();
    }
    setState(() {});
  }

  SearchBloc bloc;

  @override
  void initState() {
    getStoreAndAccount();
    bloc = SearchBloc();
    super.initState();
  }

  void fireEvent() {
    if (searchText.isNotEmpty) {
      SearchEvent event = currentTabIndex == 0
          ? SearchItem(searchText)
          : SearchStore(searchText);
      bloc..add(event);
    }
  }

  void onTabTap(int index) {
    setState(() {
      currentTabIndex = index;
      fireEvent();
    });
  }

  void textInput(String value) {
    setState(() {
      searchText = value;
      fireEvent();
    });
  }

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
        store: store,
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
                      textInput(value);
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
                  SearchProvider(
                    bloc: bloc,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  showBottomSheet(Scale screen, BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (builder) {
        return new Container(
          height: screen.vertical(250),
          color: Colour.bgColor, //Color(0xff111117),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                store != null
                    ? Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            leading: Icon(
                              Icons.local_mall_outlined,
                              color: Colors.white,
                            ),
                            title: LatoText('Create Listing'),
                          ),
                          ListTile(
                            onTap: () {},
                            leading: Icon(
                              Icons.article_outlined,
                              color: Colors.white,
                            ),
                            title: LatoText('Create Invoice'),
                          ),
                        ],
                      )
                    : ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.add_business,
                          color: Colors.white,
                        ),
                        title: LatoText('Create Store'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final bool isStoreExists;
  final GlobalKey scaffoldKey;
  final Account account;
  final Store store;
  NavigationDrawer(
      {this.isStoreExists = false, this.scaffoldKey, this.account, this.store});

  NavigationBloc bloc;

  void navigate<T>(T event) {
    bloc.push(MaterialProviderRoute<T>(route: event));
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<NavigationBloc>(context);
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
                    // color: Colour.textfieldColor,
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
                  onTap: () {
                    navigate<StoreWidgetProvider>(StoreWidgetProvider(
                      sid: store.id,
                    ));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: LatoText("Store", size: 18),
                  ),
                ),
              if (isStoreExists)
                InkWell(
                  child: ListTile(
                    leading: Icon(
                      Icons.local_mall_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: LatoText("Listings", size: 18),
                  ),
                ),
              if (isStoreExists)
                InkWell(
                  child: ListTile(
                    leading: Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: LatoText("Previous Works", size: 18),
                  ),
                ),
              if (isStoreExists)
                InkWell(
                  child: ListTile(
                    leading: Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: LatoText("Reviews", size: 18),
                  ),
                ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.green[400],
                    size: 28,
                  ),
                  title: LatoText("Contact Us", size: 18),
                ),
              ),
            ],
          )),
    );
  }
}
