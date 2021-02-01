import 'dart:io';

import 'package:locie/models/category.dart';

class Listing {
  String id;
  String name;
  String image;
  String parent;
  String parentName;
  String store;
  String unit;
  double priceMin;
  double priceMax;
  String description;
  DateTime created;
  bool inStock;
  File imageFile;
  List<String> nGram;
  Category category;

  Listing(
      {this.id,
      this.name,
      this.imageFile,
      this.image,
      this.parent,
      this.store,
      this.unit,
      this.priceMin,
      this.priceMax,
      this.description,
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
    nGram = json['n_gram'];
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
    return data;
  }
}
