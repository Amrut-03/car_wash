import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget imagePreview(Map<String, File> imagesMap, String? carImage) {
  if (carImage == null || carImage.isEmpty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svg/Camera.svg'),
        Text(
          'Car Picture',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFF6750A4),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  } else if (carImage.contains('https://')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child: Image.network(
        carImage,
        height: 78.h,
        width: 120.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/Camera.svg'),
              Text(
                'Car Picture',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFF6750A4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  } else {
    return Image.file(
      imagesMap[carImage] as File,
      fit: BoxFit.cover,
    );
  }
}
