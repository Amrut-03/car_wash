import 'dart:convert';

import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/employee/cleanedCars.dart';
import 'package:car_wash/features/employee/createEmployee.dart';
import 'package:car_wash/features/employee/editEmployee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EmployeeController extends GetxController {
  var isLoading = true.obs;
  var noRecordsFound = false.obs;
  var employeeList = <dynamic>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeList();
    searchController.addListener(() {
      fetchEmployeeList();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchEmployeeList() async {
    isLoading(true);
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://wash.sortbe.com/API/Admin/User/User-List'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'search_name': searchController.text
    });

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();

    try {
      var responseBody = jsonDecode(temp);

      if (response.statusCode == 200 && responseBody['status'] == 'Success') {
        employeeList(responseBody['data'] ?? []);
        noRecordsFound(employeeList.isEmpty);
      } else {
        print('Error: ${responseBody['remarks']}');
        employeeList([]);
        noRecordsFound(true);
      }
    } catch (e) {
      print('Failed to decode JSON: $e');
      employeeList([]);
      noRecordsFound(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeEmployee(BuildContext context, String emp_id) async {
    print("removeEmployee called with emp_id: $emp_id"); // Debug print

    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Remove'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'user_id': emp_id,
      'password': '12345665'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Employee removed successfully."); // Debug print
      awesomeTopSnackbar(
        context,
        "Employee Removed Successfully",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
      employeeList.removeWhere((employee) => employee['employee_id'] == emp_id);
      noRecordsFound(employeeList.isEmpty);
    } else {
      print('Failed to remove employee: ${response.reasonPhrase}');
    }
  }

  Future<void> confirmRemoveEmployee(
      BuildContext context, String emp_id) async {
    print("confirmRemoveEmployee called with emp_id: $emp_id"); // Debug print

    bool? shouldRemove = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTemplate.primaryClr,
          title: Text(
            'Confirm Removal',
            style: GoogleFonts.inter(color: AppTemplate.textClr),
          ),
          content: Text(
            'Are you sure you want to remove this employee?',
            style: GoogleFonts.inter(color: AppTemplate.textClr),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTemplate.bgClr),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTemplate.bgClr),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                ))
          ],
        );
      },
    );

    print("Dialog result: $shouldRemove"); // Debug print

    if (shouldRemove == true) {
      await removeEmployee(context, emp_id);
      await fetchEmployeeList(); // Re-fetch employee list after removal
    }
  }
}

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController reTypePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final EmployeeController controller = Get.put(EmployeeController());

  void showEmployeeOptions(BuildContext context, String employee_id) {
    showModalBottomSheet(
      backgroundColor: AppTemplate.primaryClr,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10.h,
                  width: 150.w,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/edit.svg'),
                  title: Text('Edit Employee',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEmployee(
                                  empid: employee_id,
                                )));
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/cleanedCars.svg'),
                  title: Text('Cleaned Cars',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CleanedCars()));
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/password.svg'),
                  title: Text('Change Password',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () {
                    showPasswordOption(context);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/removePerson.svg'),
                  title: Text('Remove Employee',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () async {
                    await controller.confirmRemoveEmployee(
                        context, employee_id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void changePassword() async {
    // Validate Password and ReTypePassword fields
    if (passwordController.text.isEmpty) {
      awesomeTopSnackbar(
        context,
        "Please Enter Password",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
      return;
    }

    if (reTypePasswordController.text.isEmpty) {
      awesomeTopSnackbar(
        context,
        "Please Enter ReTypePassword",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
      return; // Exit the function if retype password is empty
    }

    // Check if Password and ReTypePassword match
    if (passwordController.text != reTypePasswordController.text) {
      awesomeTopSnackbar(
        context,
        "Password and ReTyped Password do not match",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
      return; // Exit the function if passwords do not match
    }

    // Proceed with the network request if all validations pass
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Password'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'user_id': '92076c04ab38bea36aa757078c675080',
      'password': passwordController.text
    });

    try {
      http.StreamedResponse response = await request.send();
      String temp = await response.stream.bytesToString();
      var body = jsonDecode(temp);

      if (response.statusCode == 200) {
        awesomeTopSnackbar(
          context,
          "Password Changed Successfully",
          textStyle: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          backgroundColor: AppTemplate.bgClr,
        );
        // Navigator.pop(context);
      } else {
        awesomeTopSnackbar(
          context,
          "Error: ${body['status']}",
          textStyle: GoogleFonts.inter(
              color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          backgroundColor: AppTemplate.bgClr,
        );
      }
    } catch (e) {
      awesomeTopSnackbar(
        context,
        "An error occurred: $e",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
    }
  }

  void showPasswordOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppTemplate.primaryClr,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10.h,
                  width: 150.w,
                  margin: EdgeInsets.only(bottom: 30.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Textfieldwidget(
                    labelTxt: 'Password',
                    labelTxtClr: const Color(0xFF929292),
                    enabledBorderClr: const Color(0xFFD4D4D4),
                    focusedBorderClr: const Color(0xFFD4D4D4),
                    controller: passwordController,
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Textfieldwidget(
                    labelTxt: 'Re-Type Password',
                    labelTxtClr: const Color(0xFF929292),
                    enabledBorderClr: const Color(0xFFD4D4D4),
                    focusedBorderClr: const Color(0xFFD4D4D4),
                    controller: reTypePasswordController,
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Buttonwidget(
                      width: 227.w,
                      height: 50.h,
                      buttonClr: const Color(0xFf1E3763),
                      txt: 'Update Password',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () {
                        changePassword();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // var temp;
  // void employeeList(String searchTerm) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('https://wash.sortbe.com/API/Admin/User/User-List'),
  //   );
  //   request.fields.addAll({
  //     'enc_key': encKey,
  //     'emp_id': '123',
  //     'search_name': searchTerm,
  //   });

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var responseBody = await response.stream.bytesToString();
  //     setState(() {
  //       temp = json.decode(responseBody);
  //     });
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   searchController.addListener(() {
  //     employeeList(searchController.text);
  //   });
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   employeeList('');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          children: [
            const Header(txt: 'Employee'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Employee',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateEmployee())),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/person.svg',
                              height: 18,
                            ),
                            Positioned(
                              right: 1.w,
                              bottom: 0.h,
                              child: SvgPicture.asset(
                                'assets/svg/add.svg',
                                height: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: controller.searchController,
                cursorColor: AppTemplate.textClr,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: 'Search by Employee Name',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF929292),
                      fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Result',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Obx(() {
                    if (controller.employeeList.isEmpty) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 10.h,
                              width: 10.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.w,
                                color: const Color.fromARGB(255, 0, 52, 182),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text(
                        controller.noRecordsFound.value
                            ? 'Showing 0 of 250'
                            : 'Showing ${controller.employeeList.length} of 250',
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      );
                    }
                  }),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 52, 182),
                      ),
                    );
                  } else if (controller.employeeList.isEmpty) {
                    return Center(
                      child: Text(
                        'No employees found',
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: AppTemplate.primaryClr,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.employeeList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 150.w / 157.h,
                              ),
                              itemBuilder: (context, index) {
                                var employee = controller.employeeList[index];
                                String emp_id = employee['employee_id'];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        showEmployeeOptions(context, emp_id),
                                    child: Container(
                                      height: 157.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 50.r,
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: Image.network(
                                                  employee['employee_pic'],
                                                  fit: BoxFit.cover,
                                                  width: 100.r,
                                                  height: 100.r,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
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
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(employee['employee_name'],
                                              style: GoogleFonts.inter(
                                                  color: AppTemplate.textClr,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400)),
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
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void removeEmployee(String emp_id) async {
  //   var request = http.MultipartRequest('POST',
  //       Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Remove'));
  //   request.fields.addAll({
  //     'enc_key': encKey,
  //     'emp_id': '123',
  //     'user_id': emp_id,
  //     'password': '12345665'
  //   });

  //   http.StreamedResponse response = await request.send();
  //   String temp = await response.stream.bytesToString();
  //   var body = jsonDecode(temp);

  //   if (response.statusCode == 200 && body['status'] == 'Success') {
  //     print("+++++++++++++++++++++++++++++++++++++++++++++");
  //     print(emp_id);
  //     print("+++++++++++++++++++++++++++++++++++++++++++++");
  //     Navigator.pop(context);

  //     print(body['status']);
  //   } else {
  //     print(body['status']);
  //     print(response.reasonPhrase);
  //   }
  // }
}
