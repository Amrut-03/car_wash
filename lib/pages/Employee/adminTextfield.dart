import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Make sure this import points to the correct path

class AdminTextField extends StatefulWidget {
  AdminTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminTextField> createState() => _AdminTextFieldState();
}

class _AdminTextFieldState extends State<AdminTextField> {
  TextEditingController adminController = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? imageFile;

  Future<void> _pickImage(BuildContext context) async {
    print('_pickImage called');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print('Picked image path: ${pickedFile.path}');
      setState(() {
        imageFile = file;
      });
    } else {
      print('No image picked');
    }
  }

  void createAdmin() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Creation'));
    request.fields.addAll({
      'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
      'emp_id': '123',
      'emp_name': adminController.text,
      'phone_1': phone1Controller.text,
      'phone_2': '',
      'password': passwordController.text,
      'role': 'Admin'
    });
    request.files
        .add(await http.MultipartFile.fromPath('emp_photo', imageFile!.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Successfully')));
      print(await response.stream.bytesToString());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Failed')));
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: adminController,
            labelTxt: 'Admin Name',
            labelTxtClr: Color(0xFF929292),
            enabledBorderClr: Color(0xFFD4D4D4),
            focusedBorderClr: Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: phone1Controller,
            labelTxt: 'Phone 1',
            labelTxtClr: Color(0xFF929292),
            enabledBorderClr: Color(0xFFD4D4D4),
            focusedBorderClr: Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: passwordController,
            labelTxt: 'Password',
            labelTxtClr: Color(0xFF929292),
            enabledBorderClr: Color(0xFFD4D4D4),
            focusedBorderClr: Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 20.h),
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
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage(context);
                },
                child: Container(
                  width: 120.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xFFCCC3E5)),
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
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Buttonwidget(
              width: 227.w,
              height: 50.h,
              buttonClr: const Color(0xFf1E3763),
              txt: 'Create',
              textClr: AppTemplate.primaryClr,
              textSz: 18.sp,
              onClick: () {
                createAdmin();
              },
            ),
          ],
        ),
      ],
    );
  }
}
