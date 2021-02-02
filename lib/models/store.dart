import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  // List<PreviousExamples> previousExamples;
  String owner;
  DateTime created;
  String gstin;
  StoreLocation location;
  File imageFile;
  String logo;
  dynamic rating;

  Store(
      {this.id,
      this.name,
      this.logo,
      this.rating,
      this.contact,
      this.address,
      this.image,
      this.categories,
      this.description,
      // this.previousExamples,
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
    logo = json["logo"];
    owner = json['owner'];
    created = json['created'].toDate();
    gstin = json['gstin'];
    rating = json['rating'];
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
    // if (this.previousExamples != null) {
    //   data['previous_examples'] =
    //       this.previousExamples.map((v) => v.toJson()).toList();
    // }
    data['owner'] = this.owner;
    data['logo'] = this.logo == null ? "" : this.logo;
    data['created'] = this.created;
    data['gstin'] = this.gstin == null ? '' : this.gstin;
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
      if (!myJson.containsKey(key) || myJson[key] != value) {
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

  @override
  String toString() {
    return '$body,$city,$pinCode';
  }
}

class PreviousExample {
  String text;
  String image;
  File imageFile;
  DocumentSnapshot snapshot;

  PreviousExample({this.text, this.snapshot, this.image, this.imageFile});

  PreviousExample.fromJson(Map<String, dynamic> json) {
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

class PreviousExamples {
  String sid;
  List<PreviousExample> examples;

  PreviousExamples({this.sid, this.examples});

  PreviousExamples.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    examples = [];
    (json['examples'] as List).forEach((element) {
      examples.add(PreviousExample.fromJson(element));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['examples'] = this.examples.map((e) => e.toJson());
    return data;
  }
}
