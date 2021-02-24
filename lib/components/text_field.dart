import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locie/components/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final Function validator;
  final String hintText;
  final String helperText;
  final textAlignment;
  final TextInputType keyboard;
  final Widget preffixWidget;
  final bool readOnly;
  final Function onChanged;
  final String label;
  final int maxLines;
  final int maxLength;
  final int minLines;
  final Color fillColor;
  final double borderWidth;
  final BorderStyle borderStyle;
  final Color borderColor;
  CustomTextField(
      {@required this.textAlignment,
      this.onChanged,
      this.maxLines = 1,
      this.maxLength,
      this.minLines = 1,
      this.readOnly = false,
      this.preffixWidget,
      this.helperText,
      @required this.hintText,
      this.textController,
      this.validator,
      this.label,
      this.fillColor = Colour.textfieldColor,
      this.borderWidth = 0,
      this.borderColor = Colors.transparent,
      this.borderStyle = BorderStyle.none,
      this.keyboard = TextInputType.name});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboard,
      textAlign: textAlignment,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      controller: textController,
      cursorColor: Colors.white,
      autofocus: false,
      style: GoogleFonts.lato(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: preffixWidget,
        prefixStyle: GoogleFonts.lato(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
              width: borderWidth, style: borderStyle, color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              width: borderWidth, style: borderStyle, color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              width: borderWidth, style: borderStyle, color: borderColor),
        ),
        labelText: label,
        labelStyle: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
    );
  }
}
