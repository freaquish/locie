import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/get_it.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/pages/invoice_view.dart';
import 'package:locie/workers/worker_client.dart';
// import 'package:share/share.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart' as es;

class MyInvoices extends StatefulWidget {
  final List<Invoice> invoices;
  final bool received, storeExists;
  MyInvoices(this.invoices, {this.received = false, this.storeExists = false});
  @override
  _MyInvoicesState createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> with TickerProviderStateMixin {
  TabController tabController;
  MyInvoiceBloc bloc;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabChange);
    bloc = MyInvoiceBloc();
    bloc..add(getEvent());
    super.initState();
  }

  void _handleTabChange() {
    fireEvent();
  }

  void fireEvent() {
    bloc..add(getEvent());
  }

  InvoiceEvent getEvent() {
    bool sent = false;
    switch (tabController.index) {
      case 0:
        sent = widget.storeExists;
        break;
      case 1:
        sent = !widget.storeExists;
    }
    return RetreieveTabbedInvoices(sent: sent);
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

  void onBackClick(BuildContext context) {
    NavigationController.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colour.bgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colour.bgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 28.0,
            onPressed: () {
              onBackClick(context);
            },
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
            child: MyInvoiceProvider(
              bloc: bloc,
              event: RetreieveTabbedInvoices(sent: widget.storeExists),
            )),
      ),
    );
  }
}

class MyInvoicesListWidget extends StatelessWidget {
  final List<Invoice> invoices;
  MyInvoicesListWidget(this.invoices);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: invoices.length,
        itemBuilder: (context, index) => InvoiceCard(invoices[index]),
      ),
    );
  }
}

class InvoiceCard extends StatefulWidget {
  final Invoice invoice;
  InvoiceCard(this.invoice) : super(key: Key(invoice.id));

  @override
  _InvoiceCardState createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  PdfClient client;

  String nameText() {
    String seconds = widget.invoice.id.split("_")[1];
    return "..." + seconds;
  }

  void onShareClick() async {
    // File file = await client.save();
    await client.build();
    es.Share.file("Invoice to ${widget.invoice.recipientName}",
        "${widget.invoice.id}.pdf", await client.getBytes(), "application/pdf");
    // Share.shareFiles([file.path],
    //     mimeTypes: ["*/*"],
    //     subject: "Invoice for ${widget.invoice.recipientName}",
    //     text: widget.invoice.id);
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    client = PdfClient(widget.invoice);
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
            onShareClick();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText(nameText()),
              // Icon(
              //   Icons.cloud_download,
              //   color: Colors.white,
              // ),
            ],
          ),
        ),
        trailing: IconButton(
          splashRadius: 4,
          onPressed: () {
            // await client.build();
            onShareClick();
          },
          icon: Icon(
            Icons.share,
            color: Colour.submitButtonColor,
          ),
        ),
      ),
    );
  }
}
