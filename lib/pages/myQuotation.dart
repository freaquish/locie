import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/quotation_bloc.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/views/quotation/provider.dart';
// import 'package:locie/views/quotation/received_quotation.dart';
// import 'package:locie/views/quotation/sent_quotation.dart';

class QuotationWidget extends StatefulWidget {
  @override
  _QuotationWidgetState createState() => _QuotationWidgetState();
}

class _QuotationWidgetState extends State<QuotationWidget>
    with TickerProviderStateMixin {
  TabController tabController;
  LocalStorage localStorage;
  bool isStore = false;
  QuotationEvent event;
  Scale screen;
  @override
  void initState() {
    localStorage = LocalStorage();
    event = FetchSentQuotations();
    checkStoreExistance();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    tabController.addListener(handleTabSelection);

    super.initState();
  }

  checkStoreExistance() async {
    await localStorage.init();
    setState(() {
      isStore = localStorage.prefs.containsKey("sid");
    });
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  handleTabSelection() {
    final events = [FetchSentQuotations(), FetchReceivedQuotations()];
    switch (tabController.index) {
      case 0:
        event = isStore ? events[1] : events[0];
        break;
      case 1:
        event = isStore ? events[0] : events[1];
        break;
    }
    setState(() {});
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).pop();
  }

  List<Tab> getTabs() {
    List<Tab> tabs = [
      Tab(
        child: Padding(
          padding: EdgeInsets.all(screen.horizontal(3)),
          child: LatoText(
            'Sent',
            size: 16,
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.all(screen.horizontal(3)),
          child: LatoText(
            'Received',
            size: 16,
          ),
        ),
      )
    ];
    return isStore ? tabs.reversed.toList() : tabs;
  }

  @override
  Widget build(BuildContext context) {
    screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colour.bgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colour.bgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 24.0,
            onPressed: () {
              onBackClick(context);
            },
          ),
          title: LatoText('Quotation', size: 20),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: getTabs(),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PrimaryContainer(
              widget: QuotationViewProvider(event),
            )),
      ),
    );
  }
}
