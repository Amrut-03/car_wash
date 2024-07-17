import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
          ),
          Image.asset(
            'assets/images/car.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 35.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Please Login to continue with your account",
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const Textfieldwidget(
                        labelTxt: "Mobile Number",
                        labelTxtClr: Color(0xFF929292),
                        enabledBorderClr: Color(0xFFD4D4D4),
                        focusedBorderClr: Color(0xFFD4D4D4)),
                    SizedBox(
                      height: 30.h,
                    ),
                    const Textfieldwidget(
                        labelTxt: "Password",
                        labelTxtClr: Color(0xFF929292),
                        enabledBorderClr: Color(0xFFD4D4D4),
                        focusedBorderClr: Color(0xFFD4D4D4)),
                    SizedBox(
                      height: 30.h,
                    ),
                    Buttonwidget(
                      width: 290.w,
                      height: 50.h,
                      buttonClr: const Color(0xFf1E3763),
                      txt: 'Log in',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashBoard()));
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text(
                        "Authorized Access Only",
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppTemplate.textClr,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
