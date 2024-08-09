import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTextfield extends StatelessWidget {
  const SettingsTextfield({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: controller,
        cursorColor: AppTemplate.textClr,
        cursorHeight: 20.h,
        decoration: InputDecoration(
          hintText: 'Search by Name',
          hintStyle: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF929292),
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide:
                BorderSide(color: const Color(0xFFD4D4D4), width: 1.5.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide:
                BorderSide(color: const Color(0xFFD4D4D4), width: 1.5.w),
          ),
        ),
      ),
    );
  }
}
