import 'package:car_wash/Widgets/ListedCarsList.dart';
import 'package:car_wash/Widgets/RecentWashesList.dart';
import 'package:car_wash/Widgets/UpwardMenu.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerProfile extends StatefulWidget {
  CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  bool isCarWashed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          children: [
            const Header(txt: 'Customer Profile'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Container(
                decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFE1E1E1),
                          blurRadius: 4.r,
                          spreadRadius: 0.r,
                          offset: Offset(0.w, 4.h))
                    ],
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFE1E1E1))),
                child: Padding(
                  padding: EdgeInsets.all(15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abinanthan',
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '+91 98765 43210',
                            style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF001C63)),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/svg/car.svg'),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                '2',
                                style: GoogleFonts.inter(
                                    color: Color(0xFF6750A4),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.r,
                      ),
                      Text(
                        'Since May 2024',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: AppTemplate.textClr,
                            fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCarWashed = !isCarWashed;
                    });
                  },
                  child: Container(
                      width: 135.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isCarWashed
                                  ? Colors.transparent
                                  : const Color(0xFF001C63)),
                          borderRadius: BorderRadius.circular(5.r),
                          color: isCarWashed
                              ? const Color(0xFF001C63)
                              : AppTemplate.primaryClr),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        child: Center(
                          child: Text('Recent Washes',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: isCarWashed
                                    ? AppTemplate.primaryClr
                                    : const Color(0xFF001C63),
                              )),
                        ),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCarWashed = !isCarWashed;
                    });
                  },
                  child: Container(
                      width: 130.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: !isCarWashed
                                  ? Colors.transparent
                                  : const Color(0xFF001C63),
                              width: 2.w),
                          color: !isCarWashed
                              ? const Color(0xFF001C63)
                              : AppTemplate.primaryClr),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        child: Center(
                          child: Text(
                            'Listed Cars',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: !isCarWashed
                                  ? AppTemplate.primaryClr
                                  : const Color(0xFF001C63),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            isCarWashed ? const RecentWashesList() : const Listedcarslist()
          ],
        ),
      ),
    );
  }
}
