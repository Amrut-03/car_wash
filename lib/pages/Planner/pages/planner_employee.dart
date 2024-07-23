import 'dart:convert';

import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Planner/pages/planner.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EmployeePlanner extends StatefulWidget {
  const EmployeePlanner({super.key});

  @override
  State<EmployeePlanner> createState() => _EmployeePlannerState();
}

class _EmployeePlannerState extends State<EmployeePlanner> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  TextEditingController searchEmployee = TextEditingController();
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    plannerEmployeeList();
    searchEmployee.addListener(_filterEmployees);
  }

  Future<void> plannerEmployeeList() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Planner/Employee-Planner'));
    request.fields.addAll({
      'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
      'emp_id': '123',
      'search_name': '',
      'planner_date': formattedDate
    });

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var parsedData = jsonDecode(responseData);
        setState(() {
          employees = List<Employee>.from(
              parsedData['data'].map((x) => Employee.fromJson(x)));
          filteredEmployees = employees;
        });
      } else {
        print('Failed to load employees: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterEmployees() {
    String query = searchEmployee.text.toLowerCase();
    setState(() {
      filteredEmployees = employees
          .where((employee) => employee.empName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchEmployee.removeListener(_filterEmployees);
    searchEmployee.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        children: [
          const Header(txt: 'Planner'),
          SizedBox(height: 20.h),
          Text(
            'Schedule Planner - $formattedDate',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Textfieldwidget(
              controller: searchEmployee,
              labelTxt: 'Search by Employee Name',
              labelTxtClr: const Color(0xFF929292),
              enabledBorderClr: const Color(0xFFD4D4D4),
              focusedBorderClr: const Color(0xFFD4D4D4),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              color: AppTemplate.primaryClr,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filteredEmployees.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 150.w / 157.h,
                ),
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Planner(
                            empName: employee.empName,
                            empId: employee.empId,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 157.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xFFE1E1E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0.w, 4.h),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/noavatar.png'),
                              child: ClipOval(
                                child: Image.network(
                                  employee.imageUrl,
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
                            SizedBox(height: 10.h),
                            Text(
                              employee.empName,
                              style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Employee {
  final String empName;
  final String imageUrl;
  final String empId;

  Employee(
      {required this.empName, required this.imageUrl, required this.empId});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empName: json['employee_name'],
      imageUrl: json['employee_pic'],
      empId: json['employee_id'],
    );
  }
}
