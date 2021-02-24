import 'package:locie/components/color.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:flutter/material.dart';

class WorkLoadingContainer extends StatelessWidget {
  final color = 0xff262536;

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      color: Colour.bgColor,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screen.horizontal(7),
                  vertical: screen.vertical(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAnimation(
                    gradientColor: Color(color),
                    shimmerColor: Colour.bgColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colour.skeletonColor,
                      ),
                      width: screen.horizontal(100),
                      height: screen.vertical(390),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(20),
                  ),
                  SkeletonAnimation(
                    gradientColor: Color(color),
                    shimmerColor: Colour.bgColor,
                    child: Container(
                      width: screen.horizontal(100),
                      height: screen.vertical(20),
                      decoration: BoxDecoration(
                        color: Colour.skeletonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            screen.horizontal(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  SkeletonAnimation(
                    gradientColor: Color(color),
                    shimmerColor: Colour.bgColor,
                    child: Container(
                      width: screen.horizontal(100),
                      height: screen.vertical(20),
                      decoration: BoxDecoration(
                        color: Colour.skeletonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            screen.horizontal(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  SkeletonAnimation(
                    gradientColor: Color(color),
                    shimmerColor: Colour.bgColor,
                    child: Container(
                      width: screen.horizontal(100),
                      height: screen.vertical(20),
                      decoration: BoxDecoration(
                        color: Colour.skeletonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            screen.horizontal(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  SkeletonAnimation(
                    gradientColor: Color(color),
                    shimmerColor: Colour.bgColor,
                    child: Container(
                      width: screen.horizontal(50),
                      height: screen.vertical(20),
                      decoration: BoxDecoration(
                        color: Colour.skeletonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            screen.horizontal(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(40),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
