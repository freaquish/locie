import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class StoreProductWidget extends StatelessWidget {
  //TODO u have to send List image urls so that by doing indexing you can view all the image on screen this is
  // as simple as fuck , now image will not distort
  //List products and list of price. THey all have same index in list  so that the render on screen correctly to their parent product,

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screen.horizontal(6), vertical: screen.vertical(5)),
      child: Container(
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: screen.horizontal(50) / screen.vertical(470),
          children: List.generate(20, (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      width: screen.horizontal(50),
                      height: screen.vertical(390),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            image: index % 2 == 0
                                ? AssetImage('assets/images/placeholder.png')
                                : AssetImage('assets/images/Splash_Screen.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontal(3),
                        vertical: screen.vertical(10)),
                    child: RailwayText('Product Name'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screen.horizontal(3)),
                    child: LatoText(
                      'INR 34 - 40',
                      fontColor: Color(0xffFF7A00),
                      size: 12,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
