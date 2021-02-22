import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:locie/models/invoice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';

class WorkerClient {
  static Future<void> sendMessage(String phoneNumber, String data,
      {String unencoded}) async {
    String encoded = Uri.encodeFull(data);
    if (unencoded != null) {
      encoded += "%20$unencoded";
    }
    // print(encoded);
    String url = "https://wa.me/$phoneNumber?text=$encoded";
    //(url);
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

final rupeeSignPdf = "";

class PdfClient {
  final Invoice invoice;
  PdfClient(this.invoice);
  final Document pdf = Document();
  int pages;

  Future<Uint8List> imageFetch(String url) async {
    if (url.isEmpty) {
      return null;
    }
    Response<Uint8List> list = await Dio().get<Uint8List>(url,
        options: Options(responseType: ResponseType.bytes));
    return list.data;
  }

  Future<File> save() async {
    Directory output = await getExternalStorageDirectory();

    final file = File("${output.path}/${invoice.id}.pdf");
    //(file.path);
    File generated = await file.writeAsBytes(await pdf.save());
    OpenFile.open(generated.path);
    return generated;
  }

  Future<Uint8List> getBytes() async {
    return await pdf.save();
  }

  String getTimeString() {
    return invoice.timestamp.day.toString() +
        "-" +
        invoice.timestamp.month.toString() +
        "-" +
        invoice.timestamp.year.toString();
  }

  Widget subTotalWidget() {
    return ExpandedTile(
        name: "",
        price: "",
        quantity: "",
        unit: "Subtotal",
        amount: rupeeSignPdf + invoice.subTotal.toStringAsFixed(0),
        pad: 2,
        borderEnabled: false,
        textColor: PdfColors.grey700);
  }

  List<Widget> taxes() {
    if (invoice.taxes == null) return [];
    return invoice.taxes
        .map((e) => ExpandedTile(
            // color: PdfColors.black,
            // textColor: PdfColors.white,
            borderEnabled: false,
            pad: 2,
            name: "",
            price: e.factor.toStringAsFixed(2) + " %",
            quantity: "",
            unit: e.taxName,
            textColor: PdfColors.grey700,
            amount: rupeeSignPdf + e.value.toStringAsFixed(2)))
        .toList();
  }

  List<Widget> cashing() {
    List<Widget> widgets = [];
    if (invoice.discount != null) {
      widgets.add(ExpandedTile(
          name: "",
          borderEnabled: false,
          unit: "Discount",
          quantity: "",
          price: invoice.discount.factor.toStringAsFixed(2) + " %",
          pad: 2,
          textColor: PdfColors.grey700,
          amount:
              "-" + rupeeSignPdf + invoice.discount.value.toStringAsFixed(2)));
    }
    if (invoice.amountPaid != null) {
      widgets.add(ExpandedTile(
          name: "",
          quantity: "",
          borderEnabled: false,
          pad: 2,
          unit: "Received",
          price: "",
          isBold: true,
          amount: "-" + rupeeSignPdf + invoice.amountPaid.toStringAsFixed(2)));
    }
    widgets.add(ExpandedTile(
        color: PdfColors.red,
        textColor: PdfColors.white,
        name: "",
        price: "",
        unit: "Total",
        quantity: "",
        borderEnabled: false,
        isBold: true,
        amount: rupeeSignPdf + invoice.grandTotal.toStringAsFixed(2)));
    return widgets;
  }

  List<Widget> calulationWorksWidgets() {
    List<Widget> widgets = [
      SizedBox(height: 20),
      subTotalWidget(),
    ];
    widgets += taxes();
    widgets += cashing();
    return widgets;
  }

  Widget invoiceHeaderWidget() {
    return Container(
        child: Table(children: [
      TableRow(children: [
        Expanded(
            child: Text(invoice.generatorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ))),
      ])
    ]));
  }

  Widget invoiceMetaDatas() {
    return Container(
        child: Table(children: [
      TableRow(children: [
        Expanded(
            flex: 50,
            child: Text('Invoice To',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ))),
        Expanded(flex: 50, child: Text('Invoice No. ${invoice.id}')),
      ]),
      TableRow(children: [
        Expanded(
            flex: 50,
            child: Text(
                invoice.recipentStoreName == null ||
                        invoice.recipentStoreName.length > 0
                    ? invoice.recipentStoreName
                    : invoice.recipientName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ))),
        Expanded(
            flex: 50,
            child: Text(
                'Invoice Date: ${invoice.timestamp.day}-${invoice.timestamp.month}-${invoice.timestamp.year}')),
      ]),
      TableRow(children: [
        Expanded(
            flex: 50,
            child: Text(
                invoice.recipientGstin != null &&
                        invoice.recipientGstin.length > 0
                    ? "GSTIN: " + invoice.recipientGstin
                    : "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ))),
      ]),
    ]));
  }

  List<String> getAddress() {
    if (invoice.meta.address.split(",").length > 3) {
      List<String> splitted = invoice.meta.address.split(",");
      List<String> address = [];
      for (var index = 0; index < splitted.length - 3; index++) {
        address.add(splitted[index]);
      }
      return [
        address.join(","),
        splitted[splitted.length - 3],
        splitted[splitted.length - 2],
        splitted[splitted.length - 1]
      ];
    }
    return invoice.meta.address.split(",");
  }

  List<TextSpan> addressSpan(List<String> address) {
    List<TextSpan> spans = [];
    for (var index = 1; index < address.length; index++) {
      spans.add(TextSpan(text: address[index] + "\n"));
    }
    return spans;
  }

  Widget generatorMetaDatas() {
    List<String> address = getAddress();
    return Container(
        child: Table(children: [
      TableRow(children: [
        Expanded(
            child: RichText(
          text: TextSpan(
              text: address[0] + "\n",
              children: addressSpan(address) +
                  [
                    TextSpan(text: "GSTIN: ${invoice.meta.gstin}\n"),
                    TextSpan(text: "Phone: ${invoice.meta.contact}")
                  ]),
        )),
        Expanded(
            child: RichText(
                text: TextSpan(
                    text: 'Total Due\n',
                    style: TextStyle(fontSize: 24, color: PdfColors.grey700),
                    children: <TextSpan>[
              TextSpan(
                  text: 'INR ${invoice.grandTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, color: PdfColors.red))
            ])))
      ]),
    ]));
  }

  List<Widget> itemsWidget({int pageIndex = 0}) {
    List<Widget> items = [];
    if (invoice.items == null || invoice.items.length == 0) {
      return items;
    }
    items.add(ExpandedTile(
        name: "  Description",
        quantity: "Quantity",
        unit: "Unit",
        price: "Rate",
        amount: "Amount",
        textColor: PdfColors.white,
        borderEnabled: false,
        color: PdfColors.red));
    int length = (pageIndex + 1) * 5 < invoice.items.length
        ? (pageIndex + 1) * 5
        : invoice.items.length;
    for (var index = pageIndex * 5; index < length; index++) {
      Items item = invoice.items[index];
      items.add(ExpandedTile(
          name: " " + item.name,
          quantity: double.parse(item.quantity.toString()).toStringAsFixed(2),
          unit: item.unit,
          price: double.parse(item.price.toString()).toStringAsFixed(2),
          amount: double.parse(item.total.toString()).toStringAsFixed(2),
          borderEnabled: false,
          color: index % 2 == 0 ? PdfColors.grey300 : PdfColors.grey400));
    }
    return items;
  }

  List<Widget> combinableWidget({int page = 0}) {
    List<Widget> widgets = [];
    widgets.addAll(itemsWidget(pageIndex: page));
    widgets.add(Container(color: PdfColors.red, height: 4));
    widgets.addAll(calculationSubFooter(page: page));
    widgets.add(SizedBox(height: 40));
    widgets.add(Container(
        alignment: Alignment.bottomCenter,
        child: Text('THANK YOU FOR YOUR BUSINESS',
            style: TextStyle(fontSize: 18))));
    return widgets;
  }

  List<Widget> calculationSubFooter({int page = 0}) {
    List<Widget> widgets = [];
    if (invoice.items != null && page + 1 < pages) {
      widgets.add(SizedBox(height: 40));
      widgets.add(Container(
          alignment: Alignment.centerRight,
          child: Text('Continue...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))));
    } else {
      widgets.add(SizedBox(height: 20));
      widgets.add(subTotalWidget());
      widgets.addAll(taxes());
      widgets.addAll(cashing());
    }
    return widgets;
  }

  Future<void> build() async {
    Uint8List byteImage;
    if (invoice.meta != null && invoice.meta.logo != null) {
      byteImage = await imageFetch(invoice.meta.logo);
    }
    pages = invoice.items == null || invoice.items.length == 0
        ? 1
        : (invoice.items.length / 5).floor() + 1;
    for (var index = 0; index < pages; index++) {
      pdf.addPage(Page(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) {
            return Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          SizedBox(height: 20),
                          invoiceHeaderWidget(),
                          SizedBox(height: 30),
                          invoiceMetaDatas(),
                          SizedBox(height: 40),
                          generatorMetaDatas(),
                          SizedBox(height: 40),
                        ] +
                        combinableWidget(page: index)));
          }));
    }
  }
}

class ExpandedList extends StatelessWidget {
  // final String name, quantity, unit, rate, amount; 912075992
  // final PdfColor color;
  // ExpandedList({this.name, this.quantity, this.unit, this.rate, this.amount});
  @override
  Widget build(Context context) {
    return ExpandedTile(
        name: "Item name",
        quantity: "Quant",
        unit: "Unit",
        price: "Rate",
        amount: "Amount",
        color: PdfColors.black,
        textColor: PdfColors.white);
  }
}

class ExpandedItemList extends StatelessWidget {
  final Items item;
  ExpandedItemList(this.item);

  @override
  Widget build(Context context) {
    return ExpandedTile(
        name: item.name,
        quantity: item.quantity.toString(),
        unit: item.unit,
        price: rupeeSignPdf + item.price.toString(),
        amount: rupeeSignPdf + item.total.toStringAsFixed(2));
  }
}

class ExpandedTile extends StatelessWidget {
  final String name, quantity, unit, price, amount;
  final PdfColor color, textColor;
  final bool borderEnabled, isBold;
  final double pad;

  ExpandedTile(
      {this.name,
      this.quantity,
      this.unit,
      this.price,
      this.pad = 10,
      this.amount,
      this.color = PdfColors.white,
      this.borderEnabled = true,
      this.isBold = false,
      this.textColor = PdfColors.black});

  @override
  Widget build(Context context) {
    TextStyle style = TextStyle(
        color: textColor,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal);
    return Container(
        color: color,
        padding: EdgeInsets.symmetric(vertical: pad),
        child: Table(
            border: borderEnabled
                ? TableBorder.all(color: PdfColors.grey700, width: 1)
                : null,
            children: [
              TableRow(children: [
                Expanded(flex: 40, child: Text(name, style: style)),
                Expanded(flex: 12, child: Text(quantity, style: style)),
                Expanded(flex: 10, child: Text(unit, style: style)),
                Expanded(flex: 13, child: Text(price, style: style)),
                Expanded(flex: 15, child: Text(amount, style: style)),
              ])
            ]));
  }
}
