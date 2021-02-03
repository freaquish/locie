import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/constants.dart';

class CountryCodeModel extends StatelessWidget {
  final Function(String) onChange;
  const CountryCodeModel({@required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: PrimaryContainer(
        widget: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: countryCodes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: RailwayText(countryCodes[index][0]),
              onTap: () => {onChange(countryCodes[index][1])},
            );
          },
        ),
      ),
    );
  }
}
