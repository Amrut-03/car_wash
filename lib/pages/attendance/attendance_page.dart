import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Attendance'),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 450,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/employee-big-pic.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Employee Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  const Text(
                    'Anwar',
                  )
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Capture Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  const Text(
                    '16/07/2024 6:01am',
                  )
                ],
              ),
            ),
            SizedBox(height: 40.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  Expanded(
                    child: Buttonwidget(
                      width: 0.w,
                      height: 50.h,
                      buttonClr: const Color(0xFFC80000),
                      txt: 'Reject',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () {},
                    ),
                  ),
                  SizedBox(width: 60.w),
                  Expanded(
                    child: Buttonwidget(
                      width: 0.w,
                      height: 50.h,
                      buttonClr: const Color(0xFF1E3763),
                      txt: 'Approve',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () {},
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
