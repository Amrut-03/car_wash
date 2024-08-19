import 'dart:convert';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/dashboard.dart';
import 'package:car_wash/features/planner/model/admin.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveLoginStatus(
      String name, String image, String emp_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', name);
    await prefs.setString('employee_pic', image);
    await prefs.setString('emp_id', emp_id);
  }

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
          empName: jsonResponse['name'],
          id: jsonResponse['emp_id'],
          profilePic: jsonResponse['employee_pic'],
        );

        ref.read(authProvider.notifier).login(admin);
        print('Nmae - ${admin.empName}');
        print('id - ${admin.id}');
        print('pic - ${admin.profilePic}');

        String status = jsonResponse['status'];
        if (status == 'Success') {
          await _saveLoginStatus(jsonResponse['name'],
              jsonResponse['employee_pic'], jsonResponse["emp_id"]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTemplate.bgClr,
              content: Text(
                'Login Successfully',
                style: GoogleFonts.inter(
                    color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
              ),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            isLoading = false;
          });
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
            ),
          ),
        );
      }
    } on http.ClientException {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            'This is a Network Error',
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print("+++++++++++++++++++++++++++++++++++++++++++");
        print('Unexpected error: ${e.toString()}');
        print("+++++++++++++++++++++++++++++++++++++++++++");
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
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Please Login to continue with your account",
                      style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.h),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: mobileController,
                      cursorColor: AppTemplate.enabledBorderClr,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: const Color(0xFF929292),
                            fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.r),
                          borderSide: BorderSide(
                              color: AppTemplate.shadowClr, width: 1.5.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.r),
                          borderSide: BorderSide(
                              color: AppTemplate.shadowClr, width: 1.5.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Textfieldwidget(
                      labelTxt: 'Password',
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                      controller: passwordController,
                      isPassword: true,
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
                            textSz: 18.0,
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
                            fontSize: 12.0,
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
