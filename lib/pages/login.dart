import 'dart:convert';

import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/pages/dashboard.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login(BuildContext context) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://wash.sortbe.com/API/Admin/Login/Login'));
    request.fields.addAll({
      'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
      'mobile': mobileController.text,
      'password': passwordController.text
    });

    http.StreamedResponse response = await request.send();
    isLoading = true;

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      String status = jsonResponse['status'];
      if (status == 'Success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Successfully')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonResponse['remarks'])));
      }
    } else {
      isLoading = false;
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Credentials are wrong')));
    }
  }

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
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 0, 52, 182),
                            ),
                          )
                        : Buttonwidget(
                            width: 290.w,
                            height: 50.h,
                            buttonClr: const Color(0xFF1E3763),
                            txt: 'Log in',
                            textClr: AppTemplate.primaryClr,
                            textSz: 18.sp,
                            onClick: () {
                              FocusScope.of(context).unfocus();
                              _login(context);
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
