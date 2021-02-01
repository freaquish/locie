class Quotation {
  String user;
  String userName;
  String store;
  String storeName;
  String listing;
  String listingName;
  String listingId;
  double price;
  int quantity;
  String timestamp;
  String userContact;

  Quotation(
      {this.user,
      this.userName,
      this.store,
      this.storeName,
      this.listing,
      this.listingName,
      this.listingId,
      this.price,
      this.quantity,
      this.timestamp,
      this.userContact});

  Quotation.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    userName = json['user_name'];
    store = json['store'];
    storeName = json['store_name'];
    listing = json['listing'];
    listingName = json['listing_name'];
    listingId = json['listing_id'];
    price = json['price'];
    quantity = json['quantity'];
    timestamp = json['timestamp'];
    userContact = json['user_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['user_name'] = this.userName;
    data['store'] = this.store;
    data['store_name'] = this.storeName;
    data['listing'] = this.listing;
    data['listing_name'] = this.listingName;
    data['listing_id'] = this.listingId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['timestamp'] = this.timestamp;
    data['user_contact'] = this.userContact;
    return data;
  }
}
