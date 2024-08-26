import 'dart:convert';
import 'dart:developer';

import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/recentWashesList.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/employee/model/employee_data_model.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CleanedCars extends ConsumerStatefulWidget {
  const CleanedCars({super.key, required this.empId});

  final String empId;

  @override
  ConsumerState<CleanedCars> createState() => _CleanedCarsState();
}

class _CleanedCarsState extends ConsumerState<CleanedCars> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEmployeeCars();
  }

  EmployeeData? employeeData;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        isLoading = true;
      });
    await fetchEmployeeCars();
  }

  Future<void> fetchEmployeeCars() async {
    const url = 'https://wash.sortbe.com/API/Admin/User/Employee-Cars';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');
    print('emp = ${widget.empId}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'user_id': widget.empId,
          'request_date': DateFormat('yyyy-MM-dd').format(selectedDate),
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        var data = responseData['data'];
        print('data $data');
        if (data != null) {
          setState(() {
            employeeData = EmployeeData.fromJson(data);
          });
        } else {
          throw Exception('Data field is null');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    } finally {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: employeeData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(txt: employeeData!.name),
                Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Container(
                    height: 130.h,
                    width: 310.w,
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        borderRadius: BorderRadius.circular(10.r),
                        border:
                            Border.all(color: Color(0xFFE1E1E1), width: 1.5.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE1E1E1),
                            offset: Offset(0.w, 4.h),
                            blurRadius: 4.r,
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25.w,
                        ),
                        Container(
                          height: 92.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE1E1E1),
                                  offset: Offset(0.w, 4.h),
                                  blurRadius: 4.r,
                                )
                              ],
                              borderRadius: BorderRadius.circular(50.r),
                              border: Border.all(
                                  color: AppTemplate.textClr, width: 1.5.w)),
                          child: ClipOval(
                            child: Image.network(
                              employeeData!.employeePic,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150.h,
                                  width: 220.h,
                                  child: Center(
                                    child: Text(
                                      'Failed to load',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              employeeData!.name,
                              style: GoogleFonts.inter(
                                  fontSize: 15.0,
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 120.w,
                              child: Text(
                                employeeData!.address,
                                style: GoogleFonts.inter(
                                    fontSize: 11.0,
                                    color: const Color(0xFF001C63),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              employeeData!.phone1,
                              style: GoogleFonts.inter(
                                  decorationThickness: 1.5.w,
                                  fontSize: 11.0,
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                  child: Text(
                    'Previous Washes',
                    style: GoogleFonts.inter(
                        fontSize: 15.0,
                        color: AppTemplate.textClr,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                  child: Container(
                    height: 30.h,
                    width: 146.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: const Color(0xFFD4D4D4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy').format(selectedDate),
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: AppTemplate.textClr,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickDate(context);
                          },
                          child: SvgPicture.asset(
                            'assets/svg/outerCalender.svg',
                            height: 15.h,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                isLoading
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : RecentWashesList(
                        wash: employeeData!.washes,
                      ),
              ],
            ),
    );
  }
}
