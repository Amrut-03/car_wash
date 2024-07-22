import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Planner/pages/planner.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeePlanner extends StatelessWidget {
  const EmployeePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchEmployee = TextEditingController();
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        children: [
          const Header(txt: 'Planner'),
          SizedBox(height: 20.h),
          Text(
            'Schedule Planner - 14 July 2024',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Textfieldwidget(
              controller: searchEmployee,
              labelTxt: 'Search by Employee Name',
              labelTxtClr: const Color(0xFF929292),
              enabledBorderClr: const Color(0xFFD4D4D4),
              focusedBorderClr: const Color(0xFFD4D4D4),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Planner(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                color: AppTemplate.primaryClr,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 150.w / 157.h,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 157.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xFFE1E1E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0.w, 4.h),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/employee-pic.png'),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Sarath',
                              style: GoogleFonts.inter(
                                  color: AppTemplate.textClr,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
