import 'package:car_wash/Widgets/ListedCarsList.dart';
import 'package:car_wash/Widgets/UpwardMenu.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerProfile extends StatelessWidget {
  const CustomerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isCarWashes = true;

    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100.h,
              width: 360.w,
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: const [
                    Color.fromARGB(255, 0, 52, 182),
                    AppTemplate.bgClr,
                    AppTemplate.bgClr,
                    AppTemplate.bgClr,
                    AppTemplate.bgClr
                  ],
                      focal: Alignment(0.8.w, -0.1.h),
                      radius: 1.5.r,
                      tileMode: TileMode.clamp)),
              child: Column(
                children: [
                  SizedBox(
                    height: 35.h,
                  ),
                  Stack(
                    children: [
                      ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DashBoard()));
                          },
                          child: const Image(
                            image: AssetImage('assets/images/backward.png'),
                          ),
                        ),
                        title: Text(
                          'Customer Profile',
                          style: GoogleFonts.inter(
                              color: AppTemplate.primaryClr,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        bottom: -2.5.h,
                        child: GestureDetector(
                          onTap: () => Menu.showMenu(context),
                          child: SizedBox(
                            height: 50.h,
                            width: 60.w,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Image(
                                image:
                                    const AssetImage('assets/images/menu1.png'),
                                height: 22.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
            Card(
              child: Container(),
            ),
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
                          )
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
                Container(
                    width: 130.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: const Color(0xFF001C63)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      child: Center(
                        child: Text(
                          'Recent Washes',
                          style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: AppTemplate.primaryClr),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                    width: 130.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                            color: const Color(0xFF001C63), width: 2.w),
                        color: AppTemplate.primaryClr),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      child: Center(
                        child: Text(
                          'Listed Cars',
                          style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF001C63)),
                        ),
                      ),
                    )),
              ],
            ),
            Listedcarslist()
          ],
        ),
      ),
    );
  }
}
