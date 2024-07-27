import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeDropdown extends ConsumerWidget {
  const EmployeeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownValue = ref.watch(dropdownProvider);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          child: Container(
            height: 45.h,
            width: 390.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: const Color(0xFFD4D4D4),
                width: 1.w,
              ),
            ),
            child: ListTile(
              title: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10.r),
                dropdownColor: AppTemplate.primaryClr,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                style: const TextStyle(color: AppTemplate.textClr),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  ref
                      .read(dropdownProvider.notifier)
                      .setDropdownValue(newValue!);
                },
                items: <String>['Employee', 'Admin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // trailing: SvgPicture.asset('assets/svg/down_arrow.svg'),
            ),
          ),
        ),
        Positioned(
            left: 30.w,
            top: -2.h,
            child: Container(
              color: AppTemplate.primaryClr,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Text(
                  'Role',
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF929292),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ))
      ],
    );
  }
}
