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

  final String label;
  final int maxLines;
  final int maxLength;
  final int minLines;
  CustomTextField(
      {@required this.textAlignment,
      this.maxLines = 1,
      this.maxLength,
      this.minLines = 1,
      this.readOnly = false,
      this.preffixWidget,
      this.helperText,
      @required this.hintText,
      @required this.textController,
      this.validator,
      this.label,
      @required this.keyboard});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        fillColor: Colour.textfieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
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
