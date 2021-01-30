import 'dart:io';

import 'package:locie/models/category.dart';

class StoreLocation {
  double lat;
  double long;

  StoreLocation({this.lat, this.long});

  StoreLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}

class Store {
  String id;
  String name;
  String contact;
  Address address;
  String image;
  List<String> categories;
  String description;
  List<PreviousExamples> previousExamples;
  String owner;
  DateTime created;
  String gstin;
  StoreLocation location;
  File imageFile;

  Store(
      {this.id,
      this.name,
      this.contact,
      this.address,
      this.image,
      this.categories,
      this.description,
      this.previousExamples,
      this.owner,
      this.created,
      this.gstin,
      this.location});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    image = json['image'];
    if (json['categories'] != null) {
      json['categories'].forEach((v) {
        categories.add(v);
      });
    }
    description = json['description'];
    if (json['previous_examples'] != null) {
      previousExamples = new List<PreviousExamples>();
      json['previous_examples'].forEach((v) {
        previousExamples.add(new PreviousExamples.fromJson(v));
      });
    }
    owner = json['owner'];
    created = json['created'].toDate();
    gstin = json['gstin'];
    location = StoreLocation.fromJson(json['location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    data['name'] = this.name;
    data['contact'] = this.contact;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['image'] = this.image;
    data['categories'] = [];
    if (this.categories != null) {
      data['categories'] = this.categories;
    }
    data['description'] = this.description;
    if (this.previousExamples != null) {
      data['previous_examples'] =
          this.previousExamples.map((v) => v.toJson()).toList();
    }
    data['owner'] = this.owner;
    data['created'] = this.created;
    data['gstin'] = this.gstin;
    if (location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }

  Map<String, dynamic> compare(Store store) {
    Map<String, dynamic> json = store.toJson();
    Map<String, dynamic> myJson = this.toJson();
    Map<String, dynamic> data = Map<String, dynamic>();
    json.forEach((key, value) { 
      if(!myJson.containsKey(key) || myJson[key] != value){
        data[key] = value;
      }
    });
    return data;
  }
}

class Address {
  String body;
  String city;
  String pinCode;

  Address({this.body, this.city, this.pinCode});

  Address.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    city = json['city'];
    pinCode = json['pin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['city'] = this.city;
    data['pin_code'] = this.pinCode;
    return data;
  }
}

class PreviousExamples {
  String text;
  String image;

  PreviousExamples({this.text, this.image});

  PreviousExamples.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['image'] = this.image;
    return data;
  }
}
