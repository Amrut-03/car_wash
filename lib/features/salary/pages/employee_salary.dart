import 'dart:async';
import 'dart:convert';

import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/Salary/pages/salary_calender.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/salary/model/employee_salary_model.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EmployeeSalary extends ConsumerStatefulWidget {
  const EmployeeSalary({super.key});

  @override
  ConsumerState<EmployeeSalary> createState() => _EmployeeSalaryState();
}

class _EmployeeSalaryState extends ConsumerState<EmployeeSalary> {
  TextEditingController searchEmployee = TextEditingController();
  List<EmployeeSalaryData>? employeeSalaryData;
  List<EmployeeSalaryData>? filteredEmployeeSalaryData;
  FocusNode searchEmployeeFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchEmployee.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    searchEmployee.removeListener(_onSearchTextChanged);
    searchEmployee.clear();
    searchEmployee.dispose();
    searchEmployeeFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      filterEmployeeData();
    });
  }

  void unfocusTextField() {
    if (searchEmployeeFocusNode.hasFocus) {
      searchEmployeeFocusNode.unfocus();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEmployeeData();
    searchEmployeeFocusNode.unfocus();
  }

  Future<void> fetchEmployeeData() async {
    const url = 'https://wash.sortbe.com/API/Admin/Salary/All-Employee-Salary';

    final authState = ref.watch(authProvider);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'search_name': searchEmployee.text,
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        List<dynamic> data = responseData['data'];
        if (mounted) {
          setState(() {
            employeeSalaryData =
                data.map((item) => EmployeeSalaryData.fromJson(item)).toList();
            filterEmployeeData();
          });
        }
      } else {
        throw Exception('Failed to load employee data');
      }
    } catch (e) {
      print('Error = $e');
    }
  }

  void filterEmployeeData() {
    if (employeeSalaryData == null) return;

    setState(() {
      filteredEmployeeSalaryData = employeeSalaryData!
          .where((employee) => employee.name
              .toLowerCase()
              .contains(searchEmployee.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        children: [
          const Header(txt: 'Salary'),
          SizedBox(height: 20.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Salary Scheduler',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Textfieldwidget(
              controller: searchEmployee,
              focusNode: searchEmployeeFocusNode,
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
              child: employeeSalaryData == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredEmployeeSalaryData!.isEmpty
                      ? Center(
                          child: Text(
                            'No employee with this name',
                            style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredEmployeeSalaryData!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: 150.w / 157.h,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print('Tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalaryCalender(
                                      empId: filteredEmployeeSalaryData![index]
                                          .empId,
                                    ),
                                  ),
                                );
                                searchEmployee.clear();
                                unfocusTextField();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 157.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                    color: filteredEmployeeSalaryData![index]
                                                .salary ==
                                            'Yes'
                                        ? Color(0xFFF0FFDE)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                        color: const Color(0xFFE1E1E1)),
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
                                            filteredEmployeeSalaryData![index]
                                                .employeePic,
                                            fit: BoxFit.cover,
                                            width: 100.r,
                                            height: 100.r,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                        filteredEmployeeSalaryData![index].name,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.textClr,
                                          fontSize: 15.0,
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
