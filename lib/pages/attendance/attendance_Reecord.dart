import 'dart:convert';

import 'package:car_wash/pages/attendance/attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';

class AttendanceRecord extends StatefulWidget {
  AttendanceRecord({
    Key? key,
  }) : super(key: key);

  @override
  State<AttendanceRecord> createState() => _AttendanceRecordState();
}

class _AttendanceRecordState extends State<AttendanceRecord> {
  // Future<void> attendenceApprove() async {
  //   var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           'https://wash.sortbe.com/API/Admin/Attendance/Attendance-Status'));
  //   request.fields.addAll({
  //     'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
  //     'emp_id': widget.employee_key,
  //     'attendance_user': '123',
  //     'attendance_status': 'Approve'
  //   });

  //   http.StreamedResponse response = await request.send();
  //   String temp = await response.stream.bytesToString();
  //   var body = jsonDecode(temp);

  //   if (response.statusCode == 200 && body['status'] == 'Success') {
  //     // print(await response.stream.bytesToString());
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => AttendancePage()));
  //   }
  //   else if(body['status'] == 'No record Found'){
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AttendanceRecord(employee_key: employee_key)))
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

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
                  color: const Color(0xFFB6A8DB), fontSize: 30.sp),
            )
          ],
        ),
      ),
    );
  }
}
