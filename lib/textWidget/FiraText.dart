
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FiraText extends StatelessWidget {
 String txt;
 Color txtColor;
 double txtSize;
 FontWeight txtWeight;
 FiraText(this.txt, this.txtColor, this.txtSize, this.txtWeight);
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: GoogleFonts.firaSans(
        textStyle: TextStyle(
            color: txtColor,
            fontSize: txtSize,
            fontWeight: txtWeight),
      ),
    );
  }
}