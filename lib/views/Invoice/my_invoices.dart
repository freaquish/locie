import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/workers/worker_client.dart';

class MyInvoices extends StatefulWidget {
  final List<Invoice> invoices;
  final bool received, storeExists;
  MyInvoices(this.invoices, {this.received = false, this.storeExists = false});
  @override
  _MyInvoicesState createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  List<Tab> getTabs() {
    List<Tab> tabs = [
      Tab(
        text: "Recieved",
      ),
      Tab(
        text: "Sent",
      )
    ];
    return widget.storeExists ? [tabs[1], tabs[0]] : tabs;
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colour.bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 28.0,
          onPressed: () {},
        ),
        title: LatoText(
          "Invoices",
          fontColor: Colors.white,
          size: 18,
          weight: FontWeight.bold,
        ),
        elevation: 0,
        bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: getTabs(),
          controller: tabController,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: scale.vertical(20), horizontal: scale.horizontal(4)),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.invoices.length,
          itemBuilder: (context, index) => InvoiceCard(widget.invoices[index]),
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  InvoiceCard(this.invoice) : super(key: Key(invoice.id));

  PdfClient client;

  String nameText() {
    String seconds = invoice.id.split("_")[1];
    return "..." + seconds;
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Container(
      margin: EdgeInsets.only(bottom: scale.vertical(20)),
      decoration: BoxDecoration(
          color: Colour.textfieldColor, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          Icons.save,
          color: Colors.red,
        ),
        title: InkWell(
          onTap: () async {
            print("running");
            client = PdfClient(invoice);
            await client.build();
            await client.save();
          },
          child: Row(
            // TODO: SHOW STORE NAME TIME STAMP AND SHARING
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText(nameText()),
              Icon(
                Icons.cloud_download,
                color: Colors.white,
              )
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.share,
            color: Colour.submitButtonColor,
          ),
        ),
      ),
    );
  }
}
