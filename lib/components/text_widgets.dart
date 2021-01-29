import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class RailwayText extends StatelessWidget {
  final String data;
  final double size;
  final FontWeight weight;
  final FontStyle style;
  const RailwayText(this.data,
      {Key key,
      this.size = 14,
      this.weight = FontWeight.normal,
      this.style = FontStyle.normal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.raleway(
          fontSize: size, fontStyle: style, fontWeight: weight),
    );
  }
}

class LatoText extends StatelessWidget {
  final String data;
  final double size;
  final FontWeight weight;
  final FontStyle style;
  const LatoText(this.data,
      {Key key,
      this.size = 14,
      this.weight = FontWeight.normal,
      this.style = FontStyle.normal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.lato(
          fontSize: size, fontStyle: style, fontWeight: weight),
    );
  }
}
