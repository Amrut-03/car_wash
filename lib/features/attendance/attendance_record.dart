import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceRecord extends StatefulWidget {
  const AttendanceRecord({
    super.key,
  });

  @override
  State<AttendanceRecord> createState() => _AttendanceRecordState();
}

class _AttendanceRecordState extends State<AttendanceRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Header(txt: 'Attendance'),
            SizedBox(
              height: 250.h,
            ),
            Text(
              'No Records Found',
              style: GoogleFonts.inter(
                  color: const Color(0xFFB6A8DB), fontSize: 30.0),
            )
          ],
        ),
      ),
    );
  }
}
