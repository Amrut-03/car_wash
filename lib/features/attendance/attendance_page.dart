import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/attendance/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Map<String, dynamic>? currentAttendance;
  bool isLoading = true;

  Future<void> fetchAttendance() async {
    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Attendance/Attendance-List'));
    request.fields.addAll({'enc_key': encKey, 'emp_id': "123"});

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var responseBody = jsonDecode(temp);

    if (response.statusCode == 200) {
      if (responseBody['status'] == 'No-Records' || responseBody.isEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AttendanceRecord()));
      } else {
        setState(() {
          currentAttendance = responseBody;
          isLoading = false;
        });
      }
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> attendenceApprove() async {
    if (currentAttendance == null) return;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Attendance/Attendance-Status'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'attendance_user': currentAttendance!['employee_key'],
      'attendance_status': 'Approve'
    });

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var attendance = jsonDecode(temp);

    if (response.statusCode == 200) {
      setState(() {
        fetchAttendance();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            attendance['remarks'],
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AttendanceRecord()));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(txt: 'Attendance'),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 450,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                              currentAttendance!['attendance_image'])),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Employee Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          currentAttendance!['employee_name'] ?? 'No Name',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            'Capture Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          currentAttendance!['capture_time'] ?? "no time",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Buttonwidget(
                            width: 0.w,
                            height: 50.h,
                            buttonClr: const Color(0xFFC80000),
                            txt: 'Reject',
                            textClr: AppTemplate.primaryClr,
                            textSz: 18.sp,
                            onClick: () {
                              setState(() {
                                currentAttendance = null;
                              });
                              fetchAttendance();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Attendance Rejected',
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 60.w),
                        Expanded(
                          child: Buttonwidget(
                            width: 0.w,
                            height: 50.h,
                            buttonClr: const Color(0xFF1E3763),
                            txt: 'Approve',
                            textClr: AppTemplate.primaryClr,
                            textSz: 18.sp,
                            onClick: () async {
                              await attendenceApprove();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
    );
  }
}
