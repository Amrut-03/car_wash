import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfieldwidget extends StatefulWidget {
  final String labelTxt;
  final Color labelTxtClr;
  final Color enabledBorderClr;
  final Color focusedBorderClr;
  final TextEditingController controller;
  final bool
      isPassword; // New parameter to indicate if this is a password field

  const Textfieldwidget(
      {super.key,
      required this.labelTxt,
      required this.labelTxtClr,
      required this.enabledBorderClr,
      required this.focusedBorderClr,
      required this.controller,
      this.isPassword = false});

  @override
  _TextfieldwidgetState createState() => _TextfieldwidgetState();
}

class _TextfieldwidgetState extends State<Textfieldwidget> {
  bool _obscureText = true; // State to manage password visibility

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      cursorColor: widget.enabledBorderClr,
      decoration: InputDecoration(
        labelText: widget.labelTxt,
        labelStyle: GoogleFonts.inter(
            fontSize: 12.sp,
            color: widget.labelTxtClr,
            fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: widget.enabledBorderClr, width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: widget.focusedBorderClr, width: 1.5.w),
        ),
      ),
    );
  }
}
