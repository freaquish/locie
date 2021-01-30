class Listing {
  String id;
  String name;
  String image;
  String parent;
  String store;
  String unit;
  double priceMin;
  double priceMax;
  String description;
  DateTime created;
  bool inStock;

  Listing(
      {this.id,
      this.name,
      this.image,
      this.parent,
      this.store,
      this.unit,
      this.priceMin,
      this.priceMax,
      this.description,
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['parent'] = this.parent;
    data['store'] = this.store;
    data['unit'] = this.unit;
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['description'] = this.description;
    data['created'] = this.created;
    data['in_stock'] = this.inStock;
    return data;
  }
}
