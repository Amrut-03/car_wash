import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeTextfield extends StatefulWidget {
  const EmployeeTextfield({super.key});

  @override
  State<EmployeeTextfield> createState() => _EmployeeTextfieldState();
}

class _EmployeeTextfieldState extends State<EmployeeTextfield> {
  TextEditingController employeeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController phone2Controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            labelTxt: 'Employee Name',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
            controller: employeeController,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: dobController,
            labelTxt: 'Date of Birth',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: TextField(
            controller: addressController,
            maxLines: 4,
            cursorColor: AppTemplate.enabledBorderClr,
            decoration: InputDecoration(
              labelText: 'Address',
              labelStyle: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFF929292),
                  fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                    BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                    BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: phone1Controller,
            labelTxt: 'Phone 1',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: phone2Controller,
            labelTxt: 'Phone 2',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: passwordController,
            labelTxt: 'Password',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Aadhaar Card',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xFFCCC3E5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.enabledBorderClr,
                        offset: Offset(2.w, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          'assets/images/Camera.png',
                          height: 45.w,
                          width: double.infinity,
                        ),
                      ),
                      Text(
                        'Front Side',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF6750A4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xFFCCC3E5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.enabledBorderClr,
                        offset: Offset(2.w, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          'assets/images/Camera.png',
                          height: 45.w,
                          width: double.infinity,
                        ),
                      ),
                      Text(
                        'Back Side',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF6750A4),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            "Driving License",
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xFFCCC3E5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.enabledBorderClr,
                        offset: Offset(2.w, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          'assets/images/Camera.png',
                          height: 45.w,
                          width: double.infinity,
                        ),
                      ),
                      Text(
                        'Front Side',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF6750A4),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xFFCCC3E5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.enabledBorderClr,
                        offset: Offset(2.w, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          'assets/images/Camera.png',
                          height: 45.w,
                          width: double.infinity,
                        ),
                      ),
                      Text(
                        'Back Side',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF6750A4),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Employee Photo',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xFFCCC3E5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.enabledBorderClr,
                        offset: Offset(2.w, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          'assets/images/Camera.png',
                          height: 45.w,
                          width: double.infinity,
                        ),
                      ),
                      Text(
                        'Upload Photo',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF6750A4),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
