import 'package:car_wash/pages/Customer/createProfile.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Namelists extends StatelessWidget {
  const Namelists({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerProfile())),
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
                              "Abinanthan",
                              style: GoogleFonts.inter(
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp),
                            ),
                            Image(
                              image: const AssetImage(
                                'assets/images/forward.png',
                              ),
                              height: 40.h,
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
