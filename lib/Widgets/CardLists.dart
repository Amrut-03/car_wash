import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Cardlists extends StatelessWidget {
  const Cardlists({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFFE1E1E1),
                              blurRadius: 4.r,
                              spreadRadius: 0.r,
                              offset: Offset(0.w, 4.h))
                        ],
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE1E1E1))),
                    child: Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TN 45 AK 1234',
                                style: GoogleFonts.inter(
                                    color: AppTemplate.textClr,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                index == 0 ? 'Completed' : 'Pending',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: index == 0
                                        ? const Color.fromRGBO(86, 156, 0, 10)
                                        : const Color.fromRGBO(255, 195, 0, 10),
                                    fontSize: 10.sp),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: const Color(0xFF001C63)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 3.h),
                                    child: Text(
                                      'Interior Wash',
                                      style: GoogleFonts.inter(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppTemplate.primaryClr),
                                    ),
                                  )),
                              SizedBox(
                                width: 5.w,
                              ),
                              index == 0
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: const Color(0xFF001C63)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 3.h),
                                        child: Text(
                                          'Exterior Wash',
                                          style: GoogleFonts.inter(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTemplate.primaryClr),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'More Information',
                            style: GoogleFonts.inter(
                                fontStyle: FontStyle.italic,
                                color: AppTemplate.textClr,
                                fontSize: 8.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 15.h,
                      right: 20.w,
                      child: Row(
                        children: [
                          Text(
                            "Arun",
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          CircleAvatar(
                            radius: 13.r,
                            child: const ClipOval(
                              child: Image(
                                image: AssetImage('assets/images/girl.png'),
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 20.w,
              )
            ],
          );
        },
      ),
    );
  }
}
