class Review {
  String text;
  double rating;
  String store;
  String user;
  String userName;
  String userImage;

  Review(
      {this.text,
      this.rating,
      this.store,
      this.user,
      this.userName,
      this.userImage});

  Review.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    rating = json['rating'];
    store = json['store'];
    user = json['user'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['rating'] = this.rating;
    data['store'] = this.store;
    data['user'] = this.user;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    return data;
  }
}
