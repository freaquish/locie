import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/review.dart';

class StoreReviewsWidget extends StatelessWidget {
  List<Review> reviews;
  StoreReviewsWidget(this.reviews);

  ratingIcon(dynamic rating) {
    if (rating >= 0 && rating <= 1.0) {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      );
    } else if (rating >= 1 && rating <= 2) {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.redAccent,
      );
    } else if (rating >= 3 && rating <= 4) {
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.amber,
      );
    } else if (rating >= 4 && rating <= 5) {
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.lightGreen,
      );
    } else {
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(6), vertical: 0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: screen.vertical(10),
                            right: screen.horizontal(2)),
                        child: ratingIcon(reviews[index].rating),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: screen.vertical(10),
                            right: screen.horizontal(3)),
                        child:
                            LatoText(reviews[index].rating.toStringAsFixed(1)),
                      ),
                    ],
                  ),
                  tileColor: Colors.transparent,
                  subtitle: RailwayText(
                    reviews[index].text,
                    size: 14,
                    fontColor: Color(0xffc4c4c4),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(
                        bottom: screen.vertical(12), top: screen.vertical(24)),
                    child: LatoText(
                      reviews[index].userName,
                      size: 18,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: screen.horizontal(5),
                    backgroundImage: reviews[index].userImage != null &&
                            reviews[index].userImage.length > 0
                        ? NetworkImage(reviews[index].userImage)
                        : AssetImage('assets/images/user.png'),
                  ),
                );
              })),
    );
  }
}
