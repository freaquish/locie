import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/review.dart';

class StoreReviewsWidget extends StatelessWidget {
  final List<Review> reviews;
  StoreReviewsWidget(this.reviews);

  final String description =
      'Shopping is an activity in which a customer browses the available goods or services presented by one or more retailers with the potential intent to purchase a suitable selection of them. ';

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
              itemCount: 10,
              itemBuilder: (context, i) {
                return ListTile(
                  trailing: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: screen.vertical(10),
                            right: screen.horizontal(2)),
                        child: LatoText('4.8'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screen.vertical(10)),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  tileColor: Colors.transparent,
                  subtitle: RailwayText(
                    description,
                    size: 14,
                    fontColor: Color(0xffc4c4c4),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(
                        bottom: screen.vertical(12), top: screen.vertical(24)),
                    child: LatoText(
                      'Suyash Maddhesiya',
                      size: 22,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: screen.horizontal(5),
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                );
              })),
    );
  }
}
