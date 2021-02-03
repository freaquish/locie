class Unit {
  String name;
  String sign;

  Unit({this.name, this.sign});

  Unit.fromJson(dynamic json) {
    // //print's ${json["name"]}');
    name = json['name'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sign'] = this.sign;
    return data;
  }

  @override
  String toString() {
    return 'Unit(name: $name, sign: $sign)';
  }
}
