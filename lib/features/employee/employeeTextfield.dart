import 'dart:convert';
import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EmployeeTextfield extends ConsumerWidget {
  const EmployeeTextfield({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref,
      StateProvider<File?> imageProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      ref.read(imageProvider.notifier).state = file;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.buttonClr,
          content: Text(
            "Image Uploaded Successfully",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.buttonClr,
          content: Text(
            "Image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    }
  }

  Future<void> createEmployee(BuildContext context, WidgetRef ref) async {
    final empName = ref.read(employeeNameProvider).text;
    final dob = ref.read(dobControllerProvider).text;
    final address = ref.read(addressControllerProvider).text;
    final phone1 = ref.read(phone1ControllerProvider).text;
    final phone2 = ref.read(phone2ControllerProvider).text;
    final password = ref.read(passwordControllerProvider).text;

    // if (empName.isEmpty ||
    //     dob.isEmpty ||
    //     address.isEmpty ||
    //     phone1.isEmpty ||
    //     phone2.isEmpty ||
    //     password.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //         backgroundColor: AppTemplate.bgClr,
    //         content: Text(
    //           'All fields are required. Please fill in all fields.',
    //           style: GoogleFonts.inter(
    //               color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
    //         )),
    //   );
    //   return;
    // }

    if (empName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Employee Name',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Date of Birth',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Address',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (phone1.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Mobile Number',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Password',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }

    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Creation'));
    request.fields.addAll({
      'enc_key': encKey,
feature-planner
      'emp_id': ref.read(adminProvider).id,
      'emp_name': empName,
      'dob': dob,
      'address': address,
      'phone_1': phone1,
      'phone_2': phone2,
      'password': password,
      'role': 'Employee'
    });

    final adharFront = ref.read(aadharFrontProvider.state).state;
    final adharBack = ref.read(aadharBackProvider.state).state;
    final driveFront = ref.read(driveFrontProvider.state).state;
    final driveBack = ref.read(driveBackProvider.state).state;
    final employeePhoto = ref.read(employeePhotoProvider.state).state;

    if (adharFront != null) {
      request.files.add(
          await http.MultipartFile.fromPath('aadhaar_front', adharFront.path));
    }
    if (adharBack != null) {
      request.files.add(
          await http.MultipartFile.fromPath('aadhaar_back', adharBack.path));
    }
    if (driveFront != null) {
      request.files.add(
          await http.MultipartFile.fromPath('driving_front', driveFront.path));
    }
    if (driveBack != null) {
      request.files.add(
          await http.MultipartFile.fromPath('driving_back', driveBack.path));
    }
    if (employeePhoto != null) {
      request.files.add(
          await http.MultipartFile.fromPath('emp_photo', employeePhoto.path));
    }

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              "Employee Account Created Successfully",
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            )));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              body['status'],
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            )));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            'Error: ${e.toString()}',
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adharFront = ref.watch(aadharFrontProvider);
    final adharBack = ref.watch(aadharBackProvider);
    final driveFront = ref.watch(driveFrontProvider);
    final driveBack = ref.watch(driveBackProvider);
    final employeePhoto = ref.watch(employeePhotoProvider);

    Widget imagePreview(File? image) {
      return image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: Image.file(
                image,
                height: 85.w,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              'assets/images/Camera.png',
              height: 45.w,
              width: double.infinity,
            );
    }

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
            controller: ref.read(employeeNameProvider),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: ref.read(dobControllerProvider),
            labelTxt: 'Date of Birth',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: TextField(
            controller: ref.read(addressControllerProvider),
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
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: ref.read(phone1ControllerProvider),
            labelTxt: 'Phone 1',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: ref.read(phone2ControllerProvider),
            labelTxt: 'Phone 2',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
          ),
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            controller: ref.read(passwordControllerProvider),
            labelTxt: 'Password',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
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
                onTap: () => _pickImage(context, ref, aadharFrontProvider),
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
                      imagePreview(adharFront),
                      adharFront == null
                          ? Text(
                              'Front Side',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF6750A4),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () => _pickImage(context, ref, aadharBackProvider),
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
                      imagePreview(adharBack),
                      adharBack == null
                          ? Text(
                              'Back Side',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF6750A4),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container()
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
                onTap: () => _pickImage(context, ref, driveFrontProvider),
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
                      imagePreview(driveFront),
                      driveFront == null
                          ? Text(
                              'Front Side',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF6750A4),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () => _pickImage(context, ref, driveBackProvider),
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
                      imagePreview(driveBack),
                      driveBack == null
                          ? Text(
                              'Back Side',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF6750A4),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container()
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
                onTap: () => _pickImage(context, ref, employeePhotoProvider),
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
                      imagePreview(employeePhoto),
                      employeePhoto == null
                          ? Text(
                              'Upload Photo',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF6750A4),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container()
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
              onClick: () async {
                await createEmployee(context, ref);
              },
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}
