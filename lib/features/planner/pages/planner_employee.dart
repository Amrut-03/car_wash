import 'dart:convert';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/planner/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PlannerController extends GetxController {
  var employees = <Employee>[].obs;
  var filteredEmployees = <Employee>[].obs;
  var searchEmployee = ''.obs;

  @override
  void onInit() {
    super.onInit();
    plannerEmployeeList();
    searchEmployee.listen((_) => _filterEmployees());
  }

  Future<void> plannerEmployeeList() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wash.sortbe.com/API/Admin/Planner/Employee-Planner'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'search_name': '',
      'planner_date': plannerDate
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
          employees.value = List<Employee>.from(
              parsedData['data'].map((x) => Employee.fromJson(x)));
          filteredEmployees.value = employees;
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

  void _filterEmployees() {
    String query = searchEmployee.value.toLowerCase();
    filteredEmployees.value = employees
        .where((employee) => employee.empName.toLowerCase().contains(query))
        .toList();
  }
}

class Employee {
  final String empName;
  final String imageUrl;
  final String empId;
  final String car_count;

  Employee({
    required this.car_count,
    required this.empName,
    required this.imageUrl,
    required this.empId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empName: json['employee_name'] ?? 'Unknown',
      imageUrl: json['employee_pic'] ?? '',
      empId: json['employee_id'] ?? '',
      car_count: json['car_count'] ?? '0',
    );
  }
}

class EmployeePlanner extends StatelessWidget {
  final PlannerController controller = Get.put(PlannerController());

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
            child: TextField(
              controller: TextEditingController(),
              onChanged: (value) => controller.searchEmployee.value = value,
              decoration: InputDecoration(
                labelText: 'Search by Employee Name',
                labelStyle: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF929292),
                    fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide:
                      BorderSide(color: const Color(0xFFD4D4D4), width: 1.5.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide:
                      BorderSide(color: Color(0xFFD4D4D4), width: 1.5.w),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              color: AppTemplate.primaryClr,
              child: Obx(() {
                if (controller.filteredEmployees.isEmpty) {
                  return Center(
                    child: Text(
                      'No Record Found',
                      style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.filteredEmployees.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 150.w / 157.h,
                  ),
                  itemBuilder: (context, index) {
                    final employee = controller.filteredEmployees[index];
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
                        child: Stack(
                          children: [
                            Container(
                              height: 157.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: employee.car_count.isNotEmpty &&
                                        employee.car_count != '0'
                                    ? const Color(0xFFF0FFDE)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border:
                                    Border.all(color: const Color(0xFFE1E1E1)),
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
                            if (employee.car_count.isNotEmpty &&
                                employee.car_count != '0')
                              Positioned(
                                right: 8.w,
                                top: 8.h,
                                child: CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: AppTemplate.textClr,
                                  child: Text(
                                    employee.car_count,
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
// class Employee {
//   final String empName;
//   final String imageUrl;
//   final String empId;
//   final String car_count;

//   Employee({
//     required this.car_count,
//     required this.empName,
//     required this.imageUrl,
//     required this.empId,
//   });

//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       empName: json['employee_name'] ?? 'Unknown',
//       imageUrl: json['employee_pic'] ?? '',
//       empId: json['employee_id'] ?? '',
//       car_count: json['car_count'] ?? '0', // Provide a default value
//     );
//   }
// }
