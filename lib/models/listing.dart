import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/models/category.dart';

class Listing {
  String id;
  String name;
  String image;
  String parent;
  String parentName;
  String store;
  String storeName;
  String unit;
  double priceMin;
  double priceMax;
  String description;
  DateTime created;
  bool inStock;
  File imageFile;
  List<String> nGram;
  Category category;
  DocumentSnapshot snapshot;
  double noOfQuotes;
  Listing(
      {this.id,
      this.name,
      this.snapshot,
      this.imageFile,
      this.noOfQuotes,
      this.image,
      this.parent,
      this.store,
      this.unit,
      this.priceMin,
      this.priceMax,
      this.description,
      this.storeName,
      this.parentName,
      this.category,
      this.created,
      this.inStock});

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    parent = json['parent'];
    store = json['store'];
    unit = json['unit'];
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    description = json['description'];
    created = json['created'].toDate();
    inStock = json['in_stock'];
    nGram = (json['n_gram'] as List<dynamic>).map((e) => e.toString()).toList();
    storeName = json['store_name'];
    if (json.containsKey("no_of_quotes")) {
      noOfQuotes = double.parse(json['no_of_quotes'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image == null ? "" : this.image;
    data['parent'] = this.parent;
    data['store'] = this.store;
    data['unit'] = this.unit;
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['description'] = this.description;
    data['created'] = this.created != null ? this.created : DateTime.now();
    data['in_stock'] = this.inStock;
    data['n_gram'] = this.nGram;
    data['store_name'] = this.storeName;
    data['no_of_quotes'] = this.noOfQuotes == null ? 0.0 : this.noOfQuotes;
    return data;
  }
}
