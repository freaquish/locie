import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/minions.dart';

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
  List<String> nGram;
  // List<PreviousExamples> previousExamples;
  String owner;
  DateTime created;
  String gstin;
  StoreLocation location;
  int noOfReviews;
  File imageFile;
  String logo;
  dynamic rating;
  dynamic noAvgRating;

  Store(
      {this.id,
      this.name,
      this.logo,
      this.rating,
      this.contact,
      this.address,
      this.image,
      this.categories,
      this.noOfReviews,
      this.description,
      this.noAvgRating,
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
    if (json.containsKey("categories")) {
      categories = [];
      json['categories'].forEach((v) {
        categories.add(v);
      });
    }
    description = json['description'];
    nGram = (json['n_gram'] as List<dynamic>).map((e) => e.toString()).toList();
    logo = json["logo"];
    owner = json['owner'];
    created = json['created'] is String
        ? DateTime.parse(json['created'])
        : json['created'].toDate();
    gstin = json['gstin'];
    noAvgRating = json['rating'] == null ? 0.0 : json['rating'];
    noOfReviews = json.containsKey("no_of_reviews") ? json['no_of_reviews'] : 0;
    rating = noAvgRating / (noOfReviews > 0 ? noOfReviews : 1);
    location = json['location'] == null
        ? null
        : StoreLocation.fromJson(json['location']);
  }

  Map<String, dynamic> toJson({bool storage = false}) {
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
    data['created'] = this.created == null ? DateTime.now() : this.created;
    if (storage) {
      data['created'] = data['created'].toIso8601String();
    }
    data['gstin'] = this.gstin == null ? '' : this.gstin;
    data['no_of_reviews'] = this.noOfReviews == null ? 0 : this.noOfReviews;
    data['rating'] = this.noAvgRating == null ? 0.0 : this.noAvgRating;
    if (nGram != null) {
      data['n_gram'] = nGram;
    }
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
