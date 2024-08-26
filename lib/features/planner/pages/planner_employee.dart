import 'dart:convert';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/planner/pages/planner.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Employee {
  final String empName;
  final String imageUrl;
  final String empId;
  final String carCount;

  Employee({
    required this.carCount,
    required this.empName,
    required this.imageUrl,
    required this.empId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empName: json['employee_name'] ?? 'Unknown',
      imageUrl: json['employee_pic'] ?? '',
      empId: json['employee_id'] ?? '',
      carCount: json['car_count'] ?? '0',
    );
  }
}

class EmployeePlanner extends ConsumerStatefulWidget {
  const EmployeePlanner({super.key});

  @override
  ConsumerState<EmployeePlanner> createState() => _EmployeePlannerState();
}

class _EmployeePlannerState extends ConsumerState<EmployeePlanner> {
  final TextEditingController searchController = TextEditingController();
  List<Employee> employee = [];
  List<Employee> filteredEmployee = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(_filterEmployee);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    plannerEmployeeList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.removeListener(_filterEmployee);
  }

  Future<void> plannerEmployeeList() async {
    final admin = ref.read(authProvider);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Planner/Employee-Planner'),
    );
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'search_name': searchController.text,
      'planner_date': plannerDate,
    });

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var parsedData = jsonDecode(responseData);

        print("++++++++++++++++++++++++++++++++++++++++++++++");
        print(parsedData);
        print("++++++++++++++++++++++++++++++++++++++++++++++");

        if (parsedData['data'] != null) {
          setState(() {
            employee = List<Employee>.from(
              parsedData['data'].map((x) => Employee.fromJson(x)),
            );
            filteredEmployee = employee;
          });
        } else {
          print('Data key is null in the response');
        }
      } else {
        print('Failed to load employees: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterEmployee() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredEmployee = employee.where((emp) {
        final employee = emp.empName.toLowerCase();
        // final clientName = car.clientName.toLowerCase();
        return employee.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        children: [
          const Header(txt: 'Planner'),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Schedule Planner - $formattedDate',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTemplate.textClr,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: TextField(
              controller: searchController,
              // onChanged: (value) => plannerNotifier.updateSearchQuery(value),
              decoration: InputDecoration(
                labelText: 'Search by Employee Name',
                labelStyle: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: const Color(0xFF929292),
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: const Color(0xFFD4D4D4),
                    width: 1.5.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: const Color(0xFFD4D4D4),
                    width: 1.5.w,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              color: AppTemplate.primaryClr,
              child: filteredEmployee.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No employees found',
                            style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    )
                  : GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredEmployee.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 150.w / 157.h,
                      ),
                      itemBuilder: (context, index) {
                        // final employee = plannerState.filteredEmployees[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Planner(
                                  empName: filteredEmployee[index].empName,
                                  empId: filteredEmployee[index].empId,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 157.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                    color: filteredEmployee[index]
                                                .carCount
                                                .isNotEmpty &&
                                            filteredEmployee[index].carCount !=
                                                '0'
                                        ? const Color(0xFFF0FFDE)
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
                                            filteredEmployee[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: 100.r,
                                            height: 100.r,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 100.r,
                                                width: 100.r,
                                                child: Center(
                                                  child: Text(
                                                    'Failed to load',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        filteredEmployee[index].empName,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.textClr,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (filteredEmployee[index]
                                        .carCount
                                        .isNotEmpty &&
                                    filteredEmployee[index].carCount != '0')
                                  Positioned(
                                    right: 8.w,
                                    top: 8.h,
                                    child: CircleAvatar(
                                      radius: 10.r,
                                      backgroundColor: AppTemplate.textClr,
                                      child: Text(
                                        filteredEmployee[index].carCount,
                                        style: GoogleFonts.inter(
                                            color: AppTemplate.primaryClr),
                                      ),
                                    ),
                                  )
                              ],
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
