import 'dart:convert';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/dashboard.dart';
import 'package:car_wash/features/planner/model/admin.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            'No internet connection',
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          ),
        ),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Login/Login'),
      );
      request.fields.addAll({
        'enc_key': encKey,
        'mobile': mobileController.text,
        'password': passwordController.text,
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        final admin = Admin(
          empName: jsonResponse['name'] ?? 'Unknown',
          id: jsonResponse['emp_id'] ?? '',
          profilePic: jsonResponse['employee_pic'] ?? '',
        );

        ref.read(adminProvider.notifier).state = admin;
        String status = jsonResponse['status'];
        if (status == 'Success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: AppTemplate.bgClr,
                content: Text(
                  'Login Successfully',
                  style: GoogleFonts.inter(
                      color: AppTemplate.primaryClr,
                      fontWeight: FontWeight.w400),
                )),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashBoard()),
            (Route<dynamic> route) => false, // This removes all previous routes
          );
        } else {
          setState(() {
            isLoading = false;
          });
          if (mobileController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: AppTemplate.bgClr,
                  content: Text(
                    'Please Enter Mobile Number',
                    style: GoogleFonts.inter(
                        color: AppTemplate.primaryClr,
                        fontWeight: FontWeight.w400),
                  )),
            );
          } else if (passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: AppTemplate.bgClr,
                  content: Text(
                    'Please Enter Password',
                    style: GoogleFonts.inter(
                        color: AppTemplate.primaryClr,
                        fontWeight: FontWeight.w400),
                  )),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: AppTemplate.bgClr,
                  content: Text(
                    jsonResponse['remarks'] ?? 'Login failed',
                    style: GoogleFonts.inter(
                        color: AppTemplate.primaryClr,
                        fontWeight: FontWeight.w400),
                  )),
            );
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppTemplate.bgClr,
              content: Text(
                'Credentials are wrong',
                style: GoogleFonts.inter(
                    color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
              )),
        );
      }
    } on http.ClientException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppTemplate.bgClr,
              content: Text(
                'This is a Network Error',
                style: GoogleFonts.inter(
                    color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
              ))
          // SnackBar(backgroundColor: AppTemplate.bgClr,content: Text('Network error: ${e.message}')),
          );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              'Unexpected error: ${e.toString()}',
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            )),
      );
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
