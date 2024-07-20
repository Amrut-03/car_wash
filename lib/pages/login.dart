// import 'dart:convert';
import 'dart:convert';

import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/pages/services/adminServices.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService =
      ApiService('https://wash.sortbe.com/API/Admin/Login/Login');
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // void _login() async {
  //   final response = await apiService.login(
  //     mobileController.text,
  //     passwordController.text,
  //   );
  //   var temp = jsonDecode(response.body);

  //   // if (mobileController.text.isEmpty || passwordController.text.isEmpty) {
  //   //   ScaffoldMessenger.of(context)
  //   //       .showSnackBar(const SnackBar(content: Text('Login successful!')));
  //   //   print('mobile and password should not empty');
  //   // }

  //   if (temp["status"] == "Success" && response.statusCode == 200) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Login successful!')));
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => const DashBoard()));
  //     print('Login successful!');
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Failed to login')));
  //     print('Failed to login');
  //   }
  // }

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
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Please Login to continue with your account",
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.h),
                    Textfieldwidget(
                      controller: mobileController,
                      labelTxt: "Mobile Number",
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                    ),
                    SizedBox(height: 30.h),
                    Textfieldwidget(
                      controller: passwordController,
                      labelTxt: "Password",
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                    ),
                    SizedBox(height: 30.h),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Buttonwidget(
                            width: 290.w,
                            height: 50.h,
                            buttonClr: const Color(0xFF1E3763),
                            txt: 'Log in',
                            textClr: AppTemplate.primaryClr,
                            textSz: 18.sp,
                            onClick: () {
                              // _login();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DashBoard()));
                            },
                          ),
                    SizedBox(height: 20.h),
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
