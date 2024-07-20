import 'package:car_wash/pages/Customer/customer.dart';
import 'package:car_wash/pages/Employee/employee.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu {
  static void showMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 310.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.w, 4.h),
                    blurRadius: 4.r,
                    color: Colors.black38,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    ListTile(
                        title: Text(
                          'Menu',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF003EDC),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Image(
                              image: AssetImage('assets/images/close.png'),
                            ))),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Customer())),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          const Image(
                            image: AssetImage("assets/images/car.png"),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Customer',
                            style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Employee()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 13.w,
                          ),
                          Stack(
                            children: [
                              Image(
                                image: const AssetImage(
                                    "assets/images/employee.png"),
                                height: 19.h,
                              ),
                              Positioned(
                                right: 1.2.w,
                                bottom: 1.5.w,
                                child: Image(
                                  image:
                                      const AssetImage("assets/images/bag.png"),
                                  height: 7.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            'Employee',
                            style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15.w,
                        ),
                        const Image(
                          image: AssetImage("assets/images/planner.png"),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Planner',
                          style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        const Image(
                          image: AssetImage("assets/images/salary.png"),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          'Salary',
                          style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.primaryDelta! < -7) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        width: 160.w,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 42.h,
                          ),
                          child: Container(
                            width: 130.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.w, -1.h),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
