import 'package:car_wash/Widgets/NameLists.dart';
import 'package:car_wash/Widgets/UpwardMenu.dart';
import 'package:car_wash/pages/Customer/createCustomer.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
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
                          'Customer',
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
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Customers',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateCustomer())),
                    child: Stack(
                      children: [
                        Image(
                          image: const AssetImage('assets/images/person.png'),
                          height: 30.h,
                        ),
                        Positioned(
                            right: 1.w,
                            bottom: 5.h,
                            child: Image(
                              image: const AssetImage('assets/images/add.png'),
                              height: 9.h,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                cursorColor: AppTemplate.textClr,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: '   Search by Name or Vehicle Number',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF929292),
                      fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Result',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Showing 4 of 250',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const Namelists()
          ],
        ),
      ),
    );
  }
}
