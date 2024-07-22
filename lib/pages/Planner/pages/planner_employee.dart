import 'dart:convert';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Planner/pages/planner.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EmployeePlanner extends StatefulWidget {
  const EmployeePlanner({super.key});

  @override
  State<EmployeePlanner> createState() => _EmployeePlannerState();
}

class _EmployeePlannerState extends State<EmployeePlanner> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  TextEditingController searchEmployee = TextEditingController();

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
      'planner_date': '2024-07-19'
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
          .where((employee) => employee.name.toLowerCase().contains(query))
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
            'Schedule Planner - 14 July 2024',
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
                          builder: (context) => const Planner(),
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
                              backgroundImage: NetworkImage(employee.imageUrl),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              employee.name,
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
  final String name;
  final String imageUrl;

  Employee({required this.name, required this.imageUrl});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['employee_name'],
      imageUrl: json['employee_pic'],
    );
  }
}
