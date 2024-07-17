import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/UpwardMenu.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CarWashedDetails extends StatelessWidget {
  const CarWashedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Abinanthan',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Abinanthan',
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp),
                          ),
                          Text(
                            "13 July 2024",
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp),
                          ),
                        ],
                      ),
                      Text(
                        '+91 98765 43210',
                        style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF001C63)),
                      ),
                      SizedBox(
                        height: 15.r,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exterior Wash',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: AppTemplate.textClr,
                                fontSize: 12.sp),
                          ),
                          Text(
                            'Pending',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(255, 195, 0, 10),
                                fontSize: 13.sp),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Before Wash',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppTemplate.textClr,
                    fontSize: 13.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Container(
                height: 140.h,
                width: 220.w,
                decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFE1E1E1),
                          blurRadius: 4.r,
                          spreadRadius: 0.r,
                          offset: Offset(0.w, 4.h))
                    ],
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xFFE1E1E1))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.asset(
                    'assets/images/bmw.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'After Wash',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppTemplate.textClr,
                    fontSize: 13.sp),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 69.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: const Color(0xFFC80000),
                          width: 1.5.w,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: SvgPicture.asset(
                          'assets/svg/puzzle.svg',
                        ),
                      )),
                  Buttonwidget(
                    width: 227.w,
                    height: 50.h,
                    buttonClr: const Color(0xFf1E3763),
                    txt: 'Send to Whatsapp',
                    textClr: AppTemplate.primaryClr,
                    textSz: 16.sp,
                    onClick: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const Customer(),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
