import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/attendance/attendance_record.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  Map<String, dynamic>? currentAttendance;
  bool isLoading = true;

  Future<void> fetchAttendance() async {
    final admin = ref.read(authProvider);
    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Attendance/Attendance-List'));
    request.fields.addAll({'enc_key': encKey, 'emp_id': admin.admin!.id});

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

  Future<void> attendenceUpdate(String status) async {
    final admin = ref.read(authProvider); // Use ref to access the provider
    if (currentAttendance == null) return;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Attendance/Attendance-Status'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'attendance_user': currentAttendance!['employee_key'],
      'attendance_status': status,
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
          backgroundColor: status == 'Approve' ? Colors.green : Colors.red,
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
         ? Center(
              child: Column(
              children: [
                const Header(txt: 'Attendance'),
                const Spacer(),
                Center(
                  child: Text(
                    'No records found',
                    style: GoogleFonts.inter(
                        color: AppTemplate.bgClr,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const Spacer(),
              ],
            ))
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
                          currentAttendance!['attendance_image'],
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
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
                            onClick: () async {
                              await attendenceUpdate('Reject');
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
                              await attendenceUpdate('Approve');
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
