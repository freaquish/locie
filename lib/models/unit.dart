class Unit {
  String name;
  String sign;

  Unit({this.name, this.sign});

  Unit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sign'] = this.sign;
    return data;
  }
}
