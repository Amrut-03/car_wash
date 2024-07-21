import 'package:car_wash/pages/Customer/carWashedDetails.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentWashesList extends StatelessWidget {
  const RecentWashesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarWashedDetails())),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        boxShadow: [
                          BoxShadow(
                              color: AppTemplate.shadowClr,
                              blurRadius: 4.r,
                              spreadRadius: 0.r,
                              offset: Offset(0.w, 4.h))
                        ],
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppTemplate.shadowClr)),
                    child: SizedBox(
                      height: 56.h,
                      width: 310.w,
                      child: Padding(
                        padding: EdgeInsets.all(19.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "13 July 2024 6:32am",
                              style: GoogleFonts.inter(
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp),
                            ),
                            Text(
                              index == 0 || index == 4
                                  ? 'Pending'
                                  : 'Completed',
                              style: GoogleFonts.inter(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: index == 0 || index == 4
                                      ? const Color.fromRGBO(255, 195, 0, 10)
                                      : const Color.fromRGBO(86, 156, 0, 10),
                                  fontSize: 13.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
