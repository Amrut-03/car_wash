import 'dart:convert';
import 'dart:developer';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/Salary/widgets/salary_widget.dart';
import 'package:car_wash/features/salary/model/employee_salary_model.dart';
import 'package:car_wash/features/salary/pages/individual_salary.dart';
import 'package:car_wash/features/salary/pages/individual_salary_final.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SalaryCalender extends ConsumerStatefulWidget {
  const SalaryCalender({super.key, required this.empId});
  final String empId;

  @override
  ConsumerState<SalaryCalender> createState() => _SalaryCalenderState();
}

class _SalaryCalenderState extends ConsumerState<SalaryCalender> {
  final List<int> years = List.generate(100, (index) => 2000 + index);
  late int selectedYear;
  EmployeeSalaryMonthData? employeeSalaryMonthData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    selectedYear = now.year;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEmployeeMonth();
  }

  Future<void> fetchEmployeeMonth() async {
    setState(() {
      isLoading = true;
    });
    const url =
        'https://wash.sortbe.com/API/Admin/Salary/Employee-Month-Salary';

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
          'year': selectedYear.toString(),
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        var data = responseData['data'];
        print('data $data');

        setState(() {
          employeeSalaryMonthData =
              EmployeeSalaryMonthData.fromJson(responseData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getMonthName(dynamic month) {
    int monthNumber;

    if (month is int) {
      monthNumber = month;
    } else if (month is String) {
      monthNumber = int.tryParse(month) ?? 0;
    } else {
      throw ArgumentError('Month must be an integer or a string');
    }

    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return monthNames[monthNumber - 1];
  }

  String handleMonth(dynamic month) {
    String monthString;

    if (month is int) {
      // Convert int to String
      monthString = month.toString();
    } else if (month is String) {
      // If it's already a String, use it directly
      monthString = month;
    } else {
      // Handle unexpected types
      throw ArgumentError('Month should be an int or a String');
    }

    // Optionally validate the month string if it's supposed to be a numeric month
    int? monthNumber = int.tryParse(monthString);
    if (monthNumber == null || monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Invalid month value: $monthString');
    }

    return monthString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: employeeSalaryMonthData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(txt: 'Salary History'),
                Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Container(
                    height: 130.h,
                    width: 310.w,
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            color: const Color(0xFFE1E1E1), width: 1.5.w),
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
                                  color: const Color(0xFFE1E1E1),
                                  offset: Offset(0.w, 4.h),
                                  blurRadius: 4.r,
                                )
                              ],
                              borderRadius: BorderRadius.circular(50.r),
                              border: Border.all(
                                  color: AppTemplate.textClr, width: 1.5.w)),
                          child: ClipOval(
                            child: Image.network(
                              employeeSalaryMonthData!.employeePic,
                              fit: BoxFit.cover,
                              width: 100.r,
                              height: 100.r,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/noavatar.png',
                                  fit: BoxFit.cover,
                                  width: 100.r,
                                  height: 100.r,
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
                              employeeSalaryMonthData!.employeeName,
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 120.w,
                              child: Text(
                                employeeSalaryMonthData!.address,
                                style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF001C63),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              employeeSalaryMonthData!.phone1,
                              style: GoogleFonts.inter(
                                decorationThickness: 1.5.w,
                                fontSize: 11.sp,
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    'Salary History',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppTemplate.textClr,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Container(
                    height: 34.h,
                    width: 89.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: const Color(0xFFD4D4D4),
                      ),
                    ),
                    child: Center(
                      child: DropdownButton<int>(
                        underline: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTemplate.primaryClr,
                            ),
                          ),
                        ),
                        dropdownColor: AppTemplate.primaryClr,
                        value: selectedYear,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedYear = newValue!;
                            fetchEmployeeMonth();
                          });
                        },
                        items: years.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : employeeSalaryMonthData!.data.isEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: employeeSalaryMonthData!.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            if (employeeSalaryMonthData!
                                                    .data[index].salary ==
                                                'Yes') {
                                              return IndividualSalaryFinal(
                                                employeeName:
                                                    employeeSalaryMonthData!
                                                        .employeeName,
                                                employeePic:
                                                    employeeSalaryMonthData!
                                                        .employeePic,
                                                employeeId: widget.empId,
                                                address:
                                                    employeeSalaryMonthData!
                                                        .address,
                                                phone1: employeeSalaryMonthData!
                                                    .phone1,
                                                month: handleMonth(
                                                    employeeSalaryMonthData!
                                                        .data[index].month),
                                                year: employeeSalaryMonthData!
                                                    .data[index].year,
                                              );
                                            } else {
                                              return IndividualSalary(
                                                employeeName:
                                                    employeeSalaryMonthData!
                                                        .employeeName,
                                                employeePic:
                                                    employeeSalaryMonthData!
                                                        .employeePic,
                                                employeeId: widget.empId,
                                                address:
                                                    employeeSalaryMonthData!
                                                        .address,
                                                phone1: employeeSalaryMonthData!
                                                    .phone1,
                                                month: handleMonth(
                                                    employeeSalaryMonthData!
                                                        .data[index].month),
                                                year: employeeSalaryMonthData!
                                                    .data[index].year,
                                              );
                                            }
                                          }),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTemplate.primaryClr,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTemplate.shadowClr,
                                                blurRadius: 4.r,
                                                spreadRadius: 0.r,
                                                offset: Offset(0.w, 4.h),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: AppTemplate.shadowClr,
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 52.h,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsets.all(19.w),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${getMonthName(employeeSalaryMonthData!.data[index].month)} ${employeeSalaryMonthData!.data[index].year}',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  employeeSalaryMonthData!
                                                              .data[index]
                                                              .salary ==
                                                          'Yes'
                                                      ? Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Color(
                                                                0xFF447B00),
                                                          ),
                                                          child: const Icon(
                                                            Icons.done,
                                                            color: AppTemplate
                                                                .primaryClr,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(width: 15.w),
                                                  const Icon(
                                                    Icons.chevron_right,
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
                          ),
              ],
            ),
    );
  }
}
