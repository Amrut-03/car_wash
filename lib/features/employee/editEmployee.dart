import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:intl/intl.dart';

class EditEmployee extends ConsumerStatefulWidget {
  final String empid;
  EditEmployee({
    required this.empid,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends ConsumerState<EditEmployee> {
  bool isLoading = false;
  Future<void> _pickImage(BuildContext context, WidgetRef ref,
      StateProvider<File?> imageProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      ref.read(imageProvider.notifier).state = file;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Image Uploaded Successfully",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    }
  }

  Future<void> employeeEdit(BuildContext context, WidgetRef ref) async {
    // Helper function to show snack bar
    void showValidationError(String message) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            message,
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    }

    setState(() {
      isLoading = true;
    });

    final empName = ref.read(employeeNameProvider).text;
    final dob = ref.read(dobControllerProvider).text;
    final address = ref.read(addressControllerProvider).text;
    final phone1 = ref.read(phone1ControllerProvider).text;
    final phone2 = ref.read(phone2ControllerProvider).text;

    // Field validations
    if (empName.isEmpty) {
      showValidationError("Employee name is required");
      return;
    }
    if (dob.isEmpty) {
      showValidationError("Date of Birth is required");
      return;
    }
    if (address.isEmpty) {
      showValidationError("Address is required");
      return;
    }
    if (phone1.isEmpty) {
      showValidationError("Primary phone number is required");
      return;
    }
    if (phone2.isEmpty) {
      showValidationError("Secondary phone number is required");
      return;
    }

    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Edit'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'emp_name': empName,
      'dob': dob,
      'address': address,
      'phone_1': phone1,
      'phone_2': phone2,
      'password': 'password',
      'role': 'Employee',
      'user_id': widget.empid
    });

    final aadhaarFront = ref.read(aadharFrontProvider.notifier).state;
    final aadhaarBack = ref.read(aadharBackProvider.notifier).state;
    final drivingFront = ref.read(driveFrontProvider.notifier).state;
    final drivingBack = ref.read(driveBackProvider.notifier).state;
    final empPhoto = ref.read(employeePhotoProvider.notifier).state;

    // Image validations
    if (aadhaarFront == null) {
      showValidationError("Aadhaar front image is required");
      return;
    }
    if (aadhaarBack == null) {
      showValidationError("Aadhaar back image is required");
      return;
    }
    if (drivingFront == null) {
      showValidationError("Driving License front image is required");
      return;
    }
    if (drivingBack == null) {
      showValidationError("Driving License back image is required");
      return;
    }
    if (empPhoto == null) {
      showValidationError("Employee photo is required");
      return;
    }

    request.files.add(
        await http.MultipartFile.fromPath('aadhaar_front', aadhaarFront.path));
    request.files.add(
        await http.MultipartFile.fromPath('aadhaar_back', aadhaarBack.path));
    request.files.add(
        await http.MultipartFile.fromPath('driving_front', drivingFront.path));
    request.files.add(
        await http.MultipartFile.fromPath('driving_back', drivingBack.path));
    request.files
        .add(await http.MultipartFile.fromPath('emp_photo', empPhoto.path));

    http.StreamedResponse response = await request.send();

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Employee Updated Successfully",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      Navigator.pop(context);
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeNameProvider).clear();
      ref.read(dobControllerProvider).clear();
      ref.read(addressControllerProvider).clear();
      ref.read(phone1ControllerProvider).clear();
      ref.read(phone2ControllerProvider).clear();
      ref.read(aadharFrontProvider.notifier).state = null;
      ref.read(aadharBackProvider.notifier).state = null;
      ref.read(driveFrontProvider.notifier).state = null;
      ref.read(driveBackProvider.notifier).state = null;
      ref.read(employeePhotoProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'assets/images/aadhar.png',
              height: 45.w,
              width: double.infinity,
            );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(txt: 'Edit Employee'),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Textfieldwidget(
                  controller: ref.read(employeeNameProvider),
                  labelTxt: 'Employee Name',
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
                  controller: ref.read(dobControllerProvider),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    labelStyle: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF929292),
                        fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: BorderSide(
                          color: const Color(0xFFD4D4D4), width: 1.5.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: BorderSide(
                          color: const Color(0xFFD4D4D4), width: 1.5.w),
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month,
                            color: Color(0xFFD4D4D4)),
                        onPressed: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: AppTemplate
                                      .bgClr, // header background color
                                  hintColor:
                                      AppTemplate.bgClr, // header text color
                                  colorScheme: const ColorScheme.light(
                                    primary: AppTemplate.bgClr,
                                  ), // selection color
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme
                                          .primary), // button text color
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (selectedDate != null) {
                            final DateFormat formatter =
                                DateFormat('dd/MM/yyyy');
                            final String formattedDate =
                                formatter.format(selectedDate);
                            setState(() {
                              ref.read(dobControllerProvider).text =
                                  formattedDate;
                            });
                          }
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
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
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: ref.read(phone1ControllerProvider),
                  cursorColor: AppTemplate.enabledBorderClr,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: "phone 1",
                    labelStyle: GoogleFonts.inter(
                        fontSize: 12.sp,
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
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: ref.read(phone2ControllerProvider),
                  cursorColor: AppTemplate.enabledBorderClr,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: "phone 2",
                    labelStyle: GoogleFonts.inter(
                        fontSize: 12.sp,
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
              ),
              SizedBox(
                height: 5.h,
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
                      onTap: () {
                        _pickImage(context, ref, aadharFrontProvider);
                      },
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
                      onTap: () {
                        _pickImage(context, ref, aadharBackProvider);
                      },
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
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage(context, ref, driveFrontProvider);
                      },
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
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage(context, ref, driveBackProvider);
                      },
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
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage(context, ref, employeePhotoProvider);
                      },
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
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? SizedBox(
                          width: 227.w,
                          height: 50.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 0, 52, 182),
                            ),
                          ),
                        )
                      : Buttonwidget(
                          width: 227.w,
                          height: 50.h,
                          buttonClr: const Color(0xFf1E3763),
                          txt: 'Update Employee',
                          textClr: AppTemplate.primaryClr,
                          textSz: 18.sp,
                          onClick: () async {
                            await employeeEdit(context, ref);
                            print(
                                "+++++++++++++++++++++++++++++++++++++++++++++");
                            print(widget.empid);
                            print(
                                "+++++++++++++++++++++++++++++++++++++++++++++");
                          },
                        ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
