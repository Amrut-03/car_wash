import 'package:car_wash/features/attendance/attendance_page.dart';
import 'package:car_wash/features/customer/customer.dart';
import 'package:car_wash/features/planner/pages/planner_employee.dart';
import 'package:car_wash/features/employee/employee.dart' as emp;
import 'package:car_wash/features/salary/pages/employee_salary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:car_wash/common/utils/constants.dart';

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
                height: 360.h,
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
                  padding: const EdgeInsets.only(
                      top: 40.0, left: 25.0, right: 25.0, bottom: 15.0),
                  child: SizedBox(
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: AppTemplate.textClr)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // margin: EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Menu',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF003EDC),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                                // margin: EdgeInsets.only(top: 15.0),
                                child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: SvgPicture.asset(
                                      'assets/svg/close.svg',
                                      height: 15.0,
                                      width: 15.0,
                                    )))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.h),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Customer())),
                            child: SizedBox(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppTemplate.textClr)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: SvgPicture.asset(
                                      'assets/svg/car.svg',
                                      // ignore: deprecated_member_use
                                      color: const Color(0xFF545454),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Text(
                                      'Customer',
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const emp.Employee())),
                            child: SizedBox(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppTemplate.textClr)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: SvgPicture.asset(
                                      'assets/svg/employee.svg',
                                      // ignore: deprecated_member_use
                                      color: const Color(0xFF545454),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Text(
                                      'Employee',
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployeePlanner())),
                            child: SizedBox(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppTemplate.textClr)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: SvgPicture.asset(
                                      'assets/svg/planner.svg',
                                      // ignore: deprecated_member_use
                                      color: const Color(0xFF545454),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Text(
                                      'Planner',
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployeeSalary())),
                            child: SizedBox(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppTemplate.textClr)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: SvgPicture.asset(
                                        'assets/svg/rupee.svg',
                                        height: 15.0,
                                        width: 15.0,
                                        // ignore: deprecated_member_use
                                        color: const Color(0xFF545454),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Text(
                                      'Salary',
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendancePage())),
                            child: SizedBox(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppTemplate.textClr)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: SvgPicture.asset(
                                        'assets/svg/attendance.svg',
                                        height: 15.0,
                                        width: 15.0,
                                        // ignore: deprecated_member_use
                                        color: const Color(0xFF545454),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: AppTemplate.textClr),
                                    // ),
                                    child: Text(
                                      'Attendance',
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              if (details.primaryDelta! < -7) {
                                Navigator.of(context).pop();
                              }
                            },
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              // decoration: BoxDecoration(
                              color: Colors.transparent,
                              //     border:
                              //         Border.all(color: AppTemplate.textClr)),
                              height: 60.h,
                              width: 160.w,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 50.h,
                                ),
                                child: Container(
                                  // width: 130.w,
                                  // height: 7.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
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
            ));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Debugging statements
        print('Animation value: $animation');
        print('Secondary animation value: $secondaryAnimation');
        print('Child widget: $child');

        // Ensure animation is not null
        if (animation == null) {
          print('Animation is null');
          return SizedBox.shrink();
        }

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.w, -1.h),
            end: Offset.zero,
          ).animate(animation),
          child: child ?? SizedBox.shrink(),
        );
      },
    );
  }
}
