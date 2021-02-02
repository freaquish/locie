import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class StoreWorksWidget extends StatelessWidget {
  final String description =
      'Shopping is an activity in which a customer browses the available goods or services presented by one or more retailers with the potential intent to purchase a suitable selection of them. ';

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(7), vertical: screen.vertical(10)),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, i) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screen.horizontal(100),
                    height: screen.vertical(390),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  RailwayText(
                    description,
                    size: 18,
                  ),
                  SizedBox(
                    height: screen.vertical(40),
                  ),
                ],
              );
            },
          )),
    );
  }
}
