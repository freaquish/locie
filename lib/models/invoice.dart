class Invoice {
  String recipient;
  String recipientName;
  String recipientPhoneNumber;
  String generator;
  String generatorName;
  String generatorPhoneNumber;
  DateTime timestamp;
  String id;
  List<Items> items;
  Meta meta;
  double subTotal;
  List<Taxes> taxes;
  Discount discount;
  double grandTotal;
  double amountPaid;

  Invoice(
      {this.recipient,
      this.recipientName,
      this.generator,
      this.generatorName,
      this.generatorPhoneNumber,
      this.recipientPhoneNumber,
      this.timestamp,
      this.id,
      this.items,
      this.meta,
      this.subTotal,
      this.taxes,
      this.discount,
      this.grandTotal,
      this.amountPaid});

  Invoice.fromJson(Map<String, dynamic> json) {
    recipient = json['recipient'];
    if (recipientName != null) {
      recipientName = json['recipient_name'];
    }
    recipientPhoneNumber = json['recipient_phone_number'];
    generator = json['generator'];
    generatorName = json['generator_name'];
    generatorPhoneNumber = json['generator_phone_number'];
    timestamp = json['timestamp'].toDate();
    id = json['id'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    subTotal = double.parse(json['sub_total'].toString());
    if (json['taxes'] != null) {
      taxes = new List<Taxes>();
      json['taxes'].forEach((v) {
        taxes.add(new Taxes.fromJson(v));
      });
    }
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
    grandTotal = double.parse(json['grand_total'].toString());
    amountPaid = double.parse(json['amount_paid'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient'] = this.recipient == null ? '' : this.recipient;
    data['recipient_name'] =
        this.recipientName == null ? '' : this.recipientName;
    data['recipient_phone_number'] = this.recipientPhoneNumber;
    data['generator'] = this.generator;
    data['generator_name'] = this.generatorName;
    data['generator_phone_number'] = this.generatorPhoneNumber;
    data['timestamp'] = this.timestamp;
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['sub_total'] = this.subTotal;
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((v) => v.toJson()).toList();
    }
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    data['grand_total'] = this.grandTotal;
    data['amount_paid'] = this.amountPaid;
    return data;
  }
}

class Items {
  String name;

  dynamic quantity;
  dynamic price;
  String unit;

  Items({this.name, this.quantity, this.price, this.unit});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    quantity = json['quantity'];
    price = json['price'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['unit'] = this.unit;
    return data;
  }

  double get total => price * quantity;
}

class Meta {
  String address;
  String logo;
  String contact;
  String gstin;

  Meta({this.address, this.logo, this.contact, this.gstin});

  Meta.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    logo = json['logo'];
    contact = json['contact'];
    gstin = json['gstin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['logo'] = this.logo;
    data['contact'] = this.contact;
    data['gstin'] = this.gstin;
    return data;
  }
}

class Taxes {
  double factor;
  double value;
  String taxName;

  Taxes({this.factor, this.value, this.taxName});

  Taxes.fromJson(Map<String, dynamic> json) {
    factor = double.parse(json['factor'].toString());
    value = double.parse(json['value'].toString());
    taxName = json['tax_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['factor'] = this.factor;
    data['value'] = this.value;
    data['tax_name'] = this.taxName;
    return data;
  }
}

class Discount {
  double factor;
  double value;
  // String taxName;

  Discount({this.factor, this.value});

  Discount.fromJson(Map<String, dynamic> json) {
    factor = double.parse(json['factor'].toString());
    value = double.parse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['factor'] = this.factor;
    data['value'] = this.value;
    return data;
  }
}
