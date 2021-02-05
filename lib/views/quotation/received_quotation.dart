import 'package:flutter/material.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/constants.dart';

class ReceivedQuotation extends StatefulWidget {
  @override
  _ReceivedQuotationState createState() => _ReceivedQuotationState();
}

class _ReceivedQuotationState extends State<ReceivedQuotation> {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return PrimaryContainer(
      widget: Padding(
        padding: EdgeInsets.only(
            right: screen.horizontal(4),
            left: screen.horizontal(4),
            top: screen.vertical(24)),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Container(
                  width: screen.horizontal(100),
                  height: screen.vertical(250),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screen.horizontal(4)),
                      topRight: Radius.circular(screen.horizontal(4)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontal(5),
                        vertical: screen.horizontal(5)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LatoText(
                              'Piyush Jaiswal',
                              size: 22,
                            ),
                            LatoText(
                              '23 jan',
                              size: 16,
                            )
                          ],
                        ),
                        SizedBox(height: screen.vertical(10)),
                        ListTile(
                          tileColor: Colors.black,
                          title: Padding(
                            padding: EdgeInsets.only(top: screen.vertical(20)),
                            child: LatoText(
                              'PVC Door',
                              size: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: screen.vertical(20)),
                            child: Wrap(
                              spacing: screen.horizontal(10),
                              children: [
                                LatoText(
                                  rupeeSign + ' 230 /pcs',
                                  size: 18,
                                  fontColor: Colors.amberAccent[700],
                                ),
                                LatoText(
                                  '23 pcs',
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  //TODO implement whatsapp open bloc
                  onTap: () {},
                  child: Container(
                    width: screen.horizontal(100),
                    height: screen.vertical(100),
                    decoration: BoxDecoration(
                      color: Color(0xff594694),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(screen.horizontal(4)),
                        bottomRight: Radius.circular(screen.horizontal(4)),
                      ),
                    ),
                    child: Center(
                      child: LatoText(
                        'Reply',
                        size: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screen.vertical(30),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
