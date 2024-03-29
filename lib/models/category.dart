import 'dart:io';

class Category {
  String name;
  String image;
  String id;
  String parent;
  bool isDefault;
  String store;
  File imageFile;
  String defaultParent;

  Category(
      {this.name,
      this.image = "",
      this.id,
      this.parent = "",
      this.store = "",
      this.defaultParent,
      this.imageFile,
      this.isDefault = false});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    id = json['id'];
    parent = json['parent'];
    isDefault = json['is_default'];
    store = json['store'];
    defaultParent = json['default_parent'];
  }

  toString() {
    return 'Catgeory(name:$name, id: $id, parent $parent)';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['id'] = this.id;
    data['parent'] = this.parent;
    data['is_default'] = this.isDefault;
    data['store'] = this.store;
    data['default_parent'] = this.defaultParent;
    return data;
  }
}
