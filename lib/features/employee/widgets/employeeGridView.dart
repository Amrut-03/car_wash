import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/provider/provider.dart';

// ignore: must_be_immutable
class EmployeeList extends ConsumerWidget {
  VoidCallbackAction onclick;
  EmployeeList({
    required this.onclick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeController = ref.watch(employeeProvider);
    // final customerController = ref.watch(customerProvider);
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: employeeController.employeeList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 150.w / 157.h,
      ),
      itemBuilder: (context, index) {
        var employee = employeeController.employeeList[index];
        // String emp_id = employee['employee_id'];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => onclick,
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
                    child: ClipOval(
                      child: Image.network(
                        employee['employee_pic'],
                        fit: BoxFit.cover,
                        width: 100.r,
                        height: 100.r,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/noavatar.png',
                            fit: BoxFit.cover,
                            width: 100.r,
                            height: 100.r,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    employee['employee_name'],
                    style: GoogleFonts.inter(
                      color: AppTemplate.textClr,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
