import 'package:car_wash/Widgets/EmployeedropdownMenu.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Employee/adminTextfield.dart';
import 'package:car_wash/pages/Employee/employeeTextfield.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CreateEmployee extends ConsumerWidget {
  CreateEmployee({super.key});

  bool isEmployee = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownValue = ref.watch(dropdownProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Create Employee'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Customer Creation',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            const EmployeeDropdown(),
            SizedBox(
              height: 20.h,
            ),
            if (dropdownValue == 'Employee') const EmployeeTextfield(),
            if (dropdownValue == 'Admin') AdminTextField(),
          ],
        ),
      ),
    );
  }
}
