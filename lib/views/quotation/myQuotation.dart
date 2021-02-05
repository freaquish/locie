import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/views/quotation/received_quotation.dart';
import 'package:locie/views/quotation/sent_quotation.dart';

class QuotationWidget extends StatefulWidget {
  @override
  _QuotationWidgetState createState() => _QuotationWidgetState();
}

class _QuotationWidgetState extends State<QuotationWidget>
    with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colour.bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 24.0,
          onPressed: () {},
        ),
        title: LatoText('Quotation', size: 20),
        elevation: 0,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: tabController,
          tabs: [
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
          ],
        ),
      ),
      body: TabBarView(
        physics: BouncingScrollPhysics(),
        controller: tabController,
        children: [
          SentQuotation(),
          ReceivedQuotation(),
        ],
      ),
    );
  }
}
