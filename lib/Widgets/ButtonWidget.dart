import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonwidget extends StatelessWidget {
  final double width;
  final double height;
  final Color buttonClr;
  final String txt;
  final Color textClr;
  final double textSz;
  final VoidCallback onClick;
  const Buttonwidget(
      {super.key,
      required this.width,
      required this.height,
      required this.buttonClr,
      required this.txt,
      required this.textClr,
      required this.textSz,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
          minimumSize: Size(width, height),
          backgroundColor: buttonClr),
      onPressed: onClick,
      child: Text(
        txt,
        style: GoogleFonts.inter(
            color: textClr, fontSize: textSz, fontWeight: FontWeight.w700),
      ),
    );
  }
}
