import 'dart:convert';
import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EmployeeTextfield extends ConsumerStatefulWidget {
  const EmployeeTextfield({super.key});

  @override
  _EmployeeTextfieldState createState() => _EmployeeTextfieldState();
}

class _EmployeeTextfieldState extends ConsumerState<EmployeeTextfield> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Reset text controllers
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeNameProvider).clear();
      ref.read(dobControllerProvider).clear();
      ref.read(addressControllerProvider).clear();
      ref.read(phone1ControllerProvider).clear();
      ref.read(phone2ControllerProvider).clear();
      ref.read(passwordControllerProvider).clear();
      ref.read(aadharFrontProvider.notifier).state = null;
      ref.read(aadharBackProvider.notifier).state = null;
      ref.read(driveFrontProvider.notifier).state = null;
      ref.read(driveBackProvider.notifier).state = null;
      ref.read(employeePhotoProvider.notifier).state = null;
    });
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref,
      StateProvider<File?> imageProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      ref.read(imageProvider.notifier).state = file;
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

  Future<void> createEmployee(BuildContext context, WidgetRef ref) async {
    final empName = ref.read(employeeNameProvider).text;
    final dob = ref.read(dobControllerProvider).text;
    // final formattedDob = DateFormat('dd-MM-yyyy').parse(dob);
    // final String dobForApi = DateFormat('dd-MM-yyyy').format(formattedDob);
    // print(dobForApi);
    final address = ref.read(addressControllerProvider).text;
    final phone1 = ref.read(phone1ControllerProvider).text;
    final phone2 = ref.read(phone2ControllerProvider).text;
    final password = ref.read(passwordControllerProvider).text;
    final admin = ref.read(authProvider);
    setState(() {
      isLoading = true;
    });

    // if (empName.isEmpty &&
    //     dob.isEmpty &&
    //     address.isEmpty &&
    //     phone1.isEmpty &&
    //     phone2.isEmpty &&
    //     password.isEmpty) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: AppTemplate.bgClr,
    //     content: Text(
    //       'All fields are required',
    //       style: GoogleFonts.inter(
    //           color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
    //     ),
    //   ));
    //   return;
    // }
    if (empName.isEmpty) {
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Mobile Number 1',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (phone2.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          'Please Enter Mobile Number 2',
          style: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        ),
      ));
      return;
    }
    if (password.isEmpty) {
      setState(() {
        isLoading = false;
      });
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
      'emp_id': admin.admin!.id,
      'emp_name': empName,
      'dob': dob,
      'address': address,
      'phone_1': phone1,
      'phone_2': phone2,
      'password': password,
      'role': 'Employee'
    });

    final adharFront = ref.read(aadharFrontProvider.notifier).state;
    final adharBack = ref.read(aadharBackProvider.notifier).state;
    final driveFront = ref.read(driveFrontProvider.notifier).state;
    final driveBack = ref.read(driveBackProvider.notifier).state;
    final employeePhoto = ref.read(employeePhotoProvider.notifier).state;

    if (adharFront != null) {
      request.files.add(
          await http.MultipartFile.fromPath('aadhaar_front', adharFront.path));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "aadhar front image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      return;
    }
    if (adharBack != null) {
      request.files.add(
          await http.MultipartFile.fromPath('aadhaar_back', adharBack.path));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "aadhar Back image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      return;
    }
    if (driveFront != null) {
      request.files.add(
          await http.MultipartFile.fromPath('driving_front', driveFront.path));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Driving License front image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      return;
    }
    if (driveBack != null) {
      request.files.add(
          await http.MultipartFile.fromPath('driving_back', driveBack.path));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Driving License back image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      return;
    }
    if (employeePhoto != null) {
      request.files.add(
          await http.MultipartFile.fromPath('emp_photo', employeePhoto.path));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Employee Photo is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
      return;
    }

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              "Employee Account Created Successfully",
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            )));
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              body['status'],
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            )));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adharFront = ref.watch(aadharFrontProvider);
    final adharBack = ref.watch(aadharBackProvider);
    final driveFront = ref.watch(driveFrontProvider);
    final driveBack = ref.watch(driveBackProvider);
    final employeePhoto = ref.watch(employeePhotoProvider);
    final employeeController = ref.read(employeeProvider.notifier);
    final dashboardNotifier = ref.read(dashboardProvider.notifier);

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
          : SvgPicture.asset('assets/svg/Camera.svg');
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
          child: TextField(
            controller: ref.read(dobControllerProvider),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date of Birth",
              labelStyle: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: const Color(0xFF929292),
                  fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                    BorderSide(color: const Color(0xFFD4D4D4), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                    BorderSide(color: const Color(0xFFD4D4D4), width: 1.5.w),
              ),
              suffixIcon: IconButton(
                icon:
                    const Icon(Icons.calendar_month, color: Color(0xFFD4D4D4)),
                onPressed: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor:
                              AppTemplate.bgClr, // header background color
                          hintColor: AppTemplate.bgClr, // header text color
                          colorScheme: const ColorScheme.light(
                            primary: AppTemplate.bgClr,
                          ), // selection color
                          buttonTheme: const ButtonThemeData(
                              textTheme:
                                  ButtonTextTheme.primary), // button text color
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formattedDate = formatter.format(selectedDate);
                    print("+++++++++++++++++++++++++++++");
                    print(selectedDate);
                    print("+++++++++++++++++++++++++++++");
                    setState(() {
                      ref.read(dobControllerProvider).text = formattedDate;
                    });
                  }
                },
              ),
            ),
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
                  fontSize: 12.0,
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
                  fontSize: 12.0,
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
        SizedBox(height: 10.h),
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
                  fontSize: 12.0,
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
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Textfieldwidget(
            labelTxt: 'Password',
            labelTxtClr: const Color(0xFF929292),
            enabledBorderClr: const Color(0xFFD4D4D4),
            focusedBorderClr: const Color(0xFFD4D4D4),
            controller: ref.read(passwordControllerProvider),
            isPassword: true,
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            'Aadhaar Card',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 12.0,
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
                                fontSize: 12.0,
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
                                fontSize: 12.0,
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
              fontSize: 12.0,
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
                                fontSize: 12.0,
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
                                fontSize: 12.0,
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
              fontSize: 12.0,
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
                                fontSize: 12.0,
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
                    txt: 'Create',
                    textClr: AppTemplate.primaryClr,
                    textSz: 18.0,
                    onClick: () async {
                      await createEmployee(context, ref);
                      employeeController.fetchEmployeeList();
                      dashboardNotifier.fetchDashboardData();
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
