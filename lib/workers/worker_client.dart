import 'dart:io';
import 'dart:typed_data';
// import 'package:locie/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:locie/models/invoice.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';

class WorkerClient {
  static Future<void> sendMessage(String phoneNumber, String data) async {
    String encoded = Uri.encodeFull(data);
    String url = "https://wa.me/${phoneNumber}?text=$encoded";
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Share product view deep link
  Future<void> shareProduct(String lid) async {}

  // Share store view
  Future<void> shareStore(String sid) async {}
}

final rupeeSignPdf = "";

class PdfClient {
  final Invoice invoice;
  PdfClient(this.invoice);
  final Document pdf = Document();

  Future<Uint8List> imageFetch(String url) async {
    if (url.isEmpty) {
      return null;
    }
    Response<Uint8List> list = await Dio().get<Uint8List>(url,
        options: Options(responseType: ResponseType.bytes));
    return list.data;
  }

  Future<File> save() async {
    final output = await getExternalStorageDirectory();
    final file = File("${output.path}/${invoice.id}.pdf");
    print(file.path);
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

  List<Widget> itemsWidget() {
    List<Widget> widgets = [];
    invoice.items.forEach((element) {
      widgets.add(ExpandedItemList(element));
    });
    return widgets;
  }

  Widget subTotalWidget() {
    return ExpandedTile(
        name: "Subtotal",
        price: "",
        quantity: "",
        unit: "",
        amount: rupeeSignPdf + invoice.subTotal.toStringAsFixed(0),
        color: PdfColors.black,
        textColor: PdfColors.white);
  }

  List<Widget> taxes() {
    if (invoice.taxes == null) return [];
    return invoice.taxes
        .map((e) => ExpandedTile(
            // color: PdfColors.black,
            // textColor: PdfColors.white,
            borderEnabled: false,
            name: e.taxName,
            price: e.factor.toStringAsFixed(2) + " %",
            quantity: "",
            unit: "",
            amount: rupeeSignPdf + e.value.toStringAsFixed(2)))
        .toList();
  }

  List<Widget> cashing() {
    List<Widget> widgets = [];
    if (invoice.discount != null) {
      widgets.add(ExpandedTile(
          name: "Discount",
          borderEnabled: false,
          unit: "",
          quantity: "",
          price: invoice.discount.factor.toStringAsFixed(2) + " %",
          amount:
              "-" + rupeeSignPdf + invoice.discount.value.toStringAsFixed(2)));
    }
    if (invoice.amountPaid != null) {
      widgets.add(ExpandedTile(
          name: "Amount Paid",
          quantity: "",
          borderEnabled: false,
          unit: "",
          price: "",
          amount: rupeeSignPdf + invoice.amountPaid.toStringAsFixed(2)));
    }
    widgets.add(ExpandedTile(
        color: PdfColors.black,
        textColor: PdfColors.white,
        name: "Grandtotal",
        price: "",
        unit: "",
        quantity: "",
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
    widgets += authorisation();
    return widgets;
  }

  List<Widget> authorisation() {
    return [
      SizedBox(height: 50),
      Container(
          alignment: Alignment.centerRight,
          child: Text('Authorized Signatory',
              style: TextStyle(
                  color: PdfColors.black, fontWeight: FontWeight.bold)))
    ];
  }

  Future<void> build() async {
    Uint8List byteImage;
    if (invoice.meta != null && invoice.meta.logo != null) {
      byteImage = await imageFetch(invoice.meta.logo);
    }
    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            // Top Names
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Name and address of generator
                                  Expanded(
                                      child: Container(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: invoice.generatorName +
                                                      "\n",
                                                  style: TextStyle(
                                                      color: PdfColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                        TextSpan(
                                            text: "Contact No." +
                                                invoice.meta.contact +
                                                "\n"),
                                        TextSpan(
                                            text: invoice.meta.address
                                                .split(",")
                                                .join("\n")),
                                        TextSpan(
                                            text: "\n\n" +
                                                invoice.meta.gstin +
                                                "\n",
                                            style: TextStyle(
                                                color: PdfColors.black,
                                                fontWeight: FontWeight.bold))
                                      ])))),

                                  // Logo of generator
                                  if (false && byteImage != null)
                                    Expanded(
                                        child: Container(
                                            width: 80,
                                            height: 60,
                                            child: Image(RawImage(
                                                bytes: byteImage,
                                                dpi: 520,
                                                width: 80,
                                                height: 60))))
                                ]),
                            //Date
                            SizedBox(height: 8),
                            Container(
                                child: Text("Date: ${getTimeString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            // User Name and Invoice Id
                            SizedBox(height: 20),
                            Container(
                                child: Text("Invoice Id: ${invoice.id}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 10),
                            Container(
                                child: Text(
                                    invoice.recipientName != null
                                        ? invoice.recipientName
                                        : "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            ExpandedList(),
                          ] +
                          itemsWidget() +
                          calulationWorksWidgets())));
        }));
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
  final bool borderEnabled;
  ExpandedTile(
      {this.name,
      this.quantity,
      this.unit,
      this.price,
      this.amount,
      this.color = PdfColors.white,
      this.borderEnabled = true,
      this.textColor = PdfColors.black});

  @override
  Widget build(Context context) {
    TextStyle style = TextStyle(color: textColor);
    return Container(
        color: color,
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
