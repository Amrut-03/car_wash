import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfieldwidget extends StatelessWidget {
  final String labelTxt;
  final Color labelTxtClr;
  final Color enabledBorderClr;
  final Color focusedBorderClr;
  final TextEditingController controller;
  const Textfieldwidget({
    super.key,
    required this.labelTxt,
    required this.labelTxtClr,
    required this.enabledBorderClr,
    required this.focusedBorderClr,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppTemplate.enabledBorderClr,
      decoration: InputDecoration(
        labelText: labelTxt,
        labelStyle: GoogleFonts.inter(
            fontSize: 12.sp, color: labelTxtClr, fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
        ),
      ),
    );
  }
}
