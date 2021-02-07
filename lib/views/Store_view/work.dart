import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/store.dart';

class StoreWorksWidget extends StatelessWidget {
  final PreviousExamples examples;
  StoreWorksWidget(this.examples);
  @override
  Widget build(BuildContext context) {
    //(examples.examples.length);
    final screen = Scale(context);
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screen.horizontal(7), vertical: screen.vertical(10)),
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: examples.examples.length,
            itemBuilder: (context, i) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screen.horizontal(100),
                    height: screen.vertical(390),
                    child: RichImage(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: examples.examples[i].image,
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  RailwayText(
                    examples.examples[i].text,
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
