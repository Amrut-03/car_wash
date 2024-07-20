import 'package:car_wash/Widgets/RecentWashesList.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CleanedCars extends StatelessWidget {
  const CleanedCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(txt: 'Abinanthan'),
          Padding(
            padding: EdgeInsets.all(25.w),
            child: Container(
              height: 130.h,
              width: 310.w,
              decoration: BoxDecoration(
                  color: AppTemplate.primaryClr,
                  borderRadius: BorderRadius.circular(10.r),
                  border:
                      Border.all(color: const Color(0xFFE1E1E1), width: 1.5.w),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE1E1E1),
                      offset: Offset(0.w, 4.h),
                      blurRadius: 4.r,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 25.w,
                  ),
                  Container(
                    height: 92.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE1E1E1),
                            offset: Offset(0.w, 4.h),
                            blurRadius: 4.r,
                          )
                        ],
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                            color: AppTemplate.textClr, width: 1.5.w)),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/p1.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Suresh',
                        style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: AppTemplate.textClr,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          'No.7 SBI Colony, Trichy - 620 001',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF001C63),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Text(
                        '+91 98765 41230',
                        style: GoogleFonts.inter(
                            // decoration: TextDecoration.underline,
                            // decorationStyle: TextDecorationStyle.solid,
                            decorationThickness: 1.5.w,
                            fontSize: 11.sp,
                            color: AppTemplate.textClr,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
            child: Text(
              'Previous Washes',
              style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppTemplate.textClr,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            child: Container(
              height: 30.h,
              width: 146.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: const Color(0xFFD4D4D4))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '13-07-2024',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppTemplate.textClr,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/outerCalender.svg',
                    height: 15.h,
                  )
                ],
              ),
            ),
          ),
          const RecentWashesList(),
        ],
      ),
    );
  }
}
