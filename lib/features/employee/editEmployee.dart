import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEmployee extends ConsumerStatefulWidget {
  const EditEmployee({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends ConsumerState<EditEmployee> {
  TextEditingController dobController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController phone2Controller = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  controller: employeeController,
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
                  controller: dobController,
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
                          setState(() {
                            dobController.text =
                                "${selectedDate.toLocal()}".split(' ')[0];
                          });
                        }
                      },
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
                  controller: phone1Controller,
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
                  controller: phone2Controller,
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
                                'assets/images/aadhar.png',
                                height: 70.w,
                                width: double.infinity,
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
                                'assets/images/aadhar.png',
                                height: 70.w,
                                width: double.infinity,
                              ),
                            ),
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
                                'assets/images/aadhar.png',
                                height: 70.w,
                                width: double.infinity,
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
                                'assets/images/aadhar.png',
                                height: 70.w,
                                width: double.infinity,
                              ),
                            ),
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
                                'assets/images/aadhar.png',
                                height: 70.w,
                                width: double.infinity,
                              ),
                            ),
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
                  Buttonwidget(
                    width: 227.w,
                    height: 50.h,
                    buttonClr: const Color(0xFf1E3763),
                    txt: 'Update Employee',
                    textClr: AppTemplate.primaryClr,
                    textSz: 18.sp,
                    onClick: () {
                      Navigator.pop(context);
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
