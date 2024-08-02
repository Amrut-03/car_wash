import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:car_wash/common/utils/constants.dart';

class Cardlists extends StatefulWidget {
  final dynamic data;
  String vehicleNo;
  String employeePic;
  String employeeName;
  String washType;
  String washStatus;
  String washId;
  Cardlists({
    Key? key,
    required this.vehicleNo,
    required this.employeePic,
    required this.employeeName,
    required this.washType,
    required this.washStatus,
    required this.washId,
    this.data,
  }) : super(key: key);

  @override
  State<Cardlists> createState() => _CardlistsState();
}

class _CardlistsState extends State<Cardlists> {
  @override
  Widget build(BuildContext context) {
    // Ensure `wash_info` is a list of maps
    final List washInfoList = widget.data['wash_info'] as List;

    return Expanded(
      child: ListView.builder(
        itemCount: washInfoList.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> washInfo =
              washInfoList[index] as Map<String, dynamic>;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.h), // Space between items
            padding: EdgeInsets.all(15.h),
            decoration: BoxDecoration(
              color: AppTemplate.primaryClr,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE1E1E1)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE1E1E1),
                  blurRadius: 4.r,
                  spreadRadius: 0.r,
                  offset: Offset(0.w, 4.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.vehicleNo[index], // Ensure it's a String
                      style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.washStatus[index] == "Completed"
                          ? 'Completed'
                          : 'Pending',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: washInfo["wash_status"] == "Completed"
                            ? const Color.fromRGBO(86, 156, 0, 10)
                            : const Color.fromRGBO(255, 195, 0, 10),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: const Color(0xFF001C63),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        child: Text(
                          widget.washType[index], // Ensure it's a String
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTemplate.primaryClr,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    if (widget.washType[index] == "Exterior")
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: const Color(0xFF001C63),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          child: Text(
                            'Exterior Wash',
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTemplate.primaryClr,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      widget.employeeName[index], // Ensure it's a String
                      style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    CircleAvatar(
                      radius: 13.r,
                      backgroundImage: NetworkImage(
                          widget.employeePic[index]), // Ensure it's a valid URL
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
