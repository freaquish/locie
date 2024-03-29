class Quotation {
  String user;
  String userName;
  String store;
  String storeName;
  String listing;
  String listingName;
  String listingUnit;
  double price;
  String id;
  double quantity;
  DateTime timestamp;
  String userContact;

  Quotation(
      {this.user,
      this.userName,
      this.listingUnit,
      this.store,
      this.storeName,
      this.id,
      this.listing,
      this.listingName,
      this.price,
      this.quantity,
      this.timestamp,
      this.userContact});

  Quotation.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    userName = json['user_name'];
    id = json['id'];
    store = json['store'];
    storeName = json['store_name'];
    listing = json['listing'];
    listingName = json['listing_name'];
    // listingId = json['listing_id'];
    price = json['price'];
    quantity = json['quantity'];
    timestamp = json['timestamp'].toDate();
    userContact = json['user_contact'];
    listingUnit = json['listing_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['user_name'] = this.userName;
    data['store'] = this.store;
    data['store_name'] = this.storeName;
    data['listing'] = this.listing;
    data['listing_name'] = this.listingName;
    // data['listing_id'] = this.listingId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['timestamp'] =
        this.timestamp == null ? DateTime.now() : this.timestamp;
    data['id'] = this.id;
    data['user_contact'] = this.userContact;
    data['listing_unit'] = this.listingUnit;
    return data;
  }
}
