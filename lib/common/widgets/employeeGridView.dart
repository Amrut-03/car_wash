// import 'dart:convert';

// import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
// import 'package:car_wash/common/utils/constants.dart';
// import 'package:car_wash/common/widgets/buttonWidget.dart';
// import 'package:car_wash/common/widgets/textFieldWidget.dart';
// import 'package:car_wash/features/Employee/cleanedCars.dart';
// import 'package:car_wash/features/employee/editEmployee.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class EmployeeGridView extends StatefulWidget {
//   const EmployeeGridView({super.key});

//   @override
//   State<EmployeeGridView> createState() => _EmployeeGridViewState();
// }

// class _EmployeeGridViewState extends State<EmployeeGridView> {
//   // final List<Map<String, String>> items = [
//   //   {'name': 'Abinanthan', 'image': 'assets/images/p1.png'},
//   //   {'name': 'Suresh', 'image': 'assets/images/p2.png'},
//   //   {'name': 'Abinanthan', 'image': 'assets/images/p1.png'},
//   //   {'name': 'Suresh', 'image': 'assets/images/p2.png'},
//   //   {'name': 'Abinanthan', 'image': 'assets/images/p1.png'},
//   //   {'name': 'Suresh', 'image': 'assets/images/p2.png'},
//   // ];
//   // String? emp_id;

//   TextEditingController reTypePasswordController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   void showEmployeeOptions(BuildContext context, String emp_id) {
//     showModalBottomSheet(
//       backgroundColor: AppTemplate.primaryClr,
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20.r),
//         ),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(20.r),
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 10.h,
//                   width: 150.w,
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF9B9B9B),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 ListTile(
//                   leading: SvgPicture.asset('assets/svg/edit.svg'),
//                   title: Text('Edit Employee',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w800, fontSize: 18.sp)),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => EditEmployee(empid: emp_id)));
//                   },
//                 ),
//                 ListTile(
//                   leading: SvgPicture.asset('assets/svg/cleanedCars.svg'),
//                   title: Text('Cleaned Cars',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w800, fontSize: 18.sp)),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const CleanedCars()));
//                   },
//                 ),
//                 ListTile(
//                   leading: SvgPicture.asset('assets/svg/password.svg'),
//                   title: Text('Change Password',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w800, fontSize: 18.sp)),
//                   onTap: () {
//                     showPasswordOption(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: SvgPicture.asset('assets/svg/removePerson.svg'),
//                   title: Text('Remove Employee',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w800, fontSize: 18.sp)),
//                   onTap: () {
//                     removeEmployee(emp_id);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void employeeChangePassword() async {
//     // Validate Password and ReTypePassword fields
//     if (passwordController.text.isEmpty) {
//       awesomeTopSnackbar(
//         context,
//         "Please Enter Password",
//         textStyle: GoogleFonts.inter(
//             color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         backgroundColor: AppTemplate.bgClr,
//       );
//       return; // Exit the function if password is empty
//     }

//     if (reTypePasswordController.text.isEmpty) {
//       awesomeTopSnackbar(
//         context,
//         "Please Enter ReTypePassword",
//         textStyle: GoogleFonts.inter(
//             color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         backgroundColor: AppTemplate.bgClr,
//       );
//       return; // Exit the function if retype password is empty
//     }

//     // Check if Password and ReTypePassword match
//     if (passwordController.text != reTypePasswordController.text) {
//       awesomeTopSnackbar(
//         context,
//         "Password and ReTyped Password do not match",
//         textStyle: GoogleFonts.inter(
//             color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         backgroundColor: AppTemplate.bgClr,
//       );
//       return; // Exit the function if passwords do not match
//     }

//     // Proceed with the network request if all validations pass
//     var request = http.MultipartRequest('POST',
//         Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Password'));
//     request.fields.addAll({
//       'enc_key': encKey,
//       'emp_id': '123',
//       'user_id': '92076c04ab38bea36aa757078c675080',
//       'password': passwordController.text
//     });

//     try {
//       http.StreamedResponse response = await request.send();
//       String temp = await response.stream.bytesToString();
//       var body = jsonDecode(temp);

//       if (response.statusCode == 200) {
//         awesomeTopSnackbar(
//           context,
//           "Password Changed Successfully",
//           textStyle: GoogleFonts.inter(
//               color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//           backgroundColor: AppTemplate.bgClr,
//         );
//         Navigator.pop(context);
//       } else {
//         awesomeTopSnackbar(
//           context,
//           "Error: ${body['status']}",
//           textStyle: GoogleFonts.inter(
//               color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//           backgroundColor: AppTemplate.bgClr,
//         );
//       }
//     } catch (e) {
//       awesomeTopSnackbar(
//         context,
//         "An error occurred: $e",
//         textStyle: GoogleFonts.inter(
//             color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         backgroundColor: AppTemplate.bgClr,
//       );
//     }
//   }

//   void showPasswordOption(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: AppTemplate.primaryClr,
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20.r),
//         ),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(20.r),
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 10.h,
//                   width: 150.w,
//                   margin: EdgeInsets.only(bottom: 30.h),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF9B9B9B),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25.w),
//                   child: Textfieldwidget(
//                     labelTxt: 'Password',
//                     labelTxtClr: const Color(0xFF929292),
//                     enabledBorderClr: const Color(0xFFD4D4D4),
//                     focusedBorderClr: const Color(0xFFD4D4D4),
//                     controller: passwordController,
//                     isPassword: true,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25.w),
//                   child: Textfieldwidget(
//                     labelTxt: 'Re-Type Password',
//                     labelTxtClr: const Color(0xFF929292),
//                     enabledBorderClr: const Color(0xFFD4D4D4),
//                     focusedBorderClr: const Color(0xFFD4D4D4),
//                     controller: reTypePasswordController,
//                     isPassword: true,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Buttonwidget(
//                       width: 227.w,
//                       height: 50.h,
//                       buttonClr: const Color(0xFf1E3763),
//                       txt: 'Update Password',
//                       textClr: AppTemplate.primaryClr,
//                       textSz: 18.sp,
//                       onClick: () {
//                         employeeChangePassword();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   var temp;

//   void employeeList() async {
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('https://wash.sortbe.com/API/Admin/User/User-List'));
//     request.fields.addAll(
//       {'enc_key': encKey, 'emp_id': '123', 'search_name': ''},
//     );

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseBody = await response.stream.bytesToString();
//       setState(() {
//         temp = json.decode(responseBody);
//       });
//     } else {
//       print(response.reasonPhrase);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     employeeList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTemplate.primaryClr,
//       body: temp == null
//           ? Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 200.h,
//                   ),
//                   const CircularProgressIndicator(
//                     color: Color.fromARGB(255, 0, 52, 182),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     color: AppTemplate.primaryClr,
//                     child: GridView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: temp['data'].length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 10.w,
//                         mainAxisSpacing: 10.h,
//                         childAspectRatio: 150.w / 157.h,
//                       ),
//                       itemBuilder: (context, index) {
//                         var employee = temp['data'][index];
//                         String emp_id = employee['employee_id'];
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               showEmployeeOptions(context, emp_id);
//                               print(emp_id);
//                             },
//                             child: Container(
//                               height: 157.h,
//                               width: 150.w,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10.r),
//                                 border:
//                                     Border.all(color: const Color(0xFFE1E1E1)),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     offset: Offset(0.w, 4.h),
//                                     blurRadius: 4.r,
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                       radius: 50.r,
//                                       backgroundImage: NetworkImage(
//                                           employee['employee_pic'])),
//                                   SizedBox(height: 10.h),
//                                   Text(employee['employee_name'],
//                                       style: GoogleFonts.inter(
//                                           color: AppTemplate.textClr,
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w400)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   void removeEmployee(String emp_id) async {
//     var request = http.MultipartRequest('POST',
//         Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Remove'));
//     request.fields.addAll({
//       'enc_key': encKey,
//       'emp_id': '123',
//       'user_id': emp_id,
//       'password': '12345665'
//     });

//     http.StreamedResponse response = await request.send();
//     String temp = await response.stream.bytesToString();
//     var body = jsonDecode(temp);

//     if (response.statusCode == 200 && body['status'] == 'Success') {
//       awesomeTopSnackbar(
//         context,
//         "Employee Removed Successfully",
//         textStyle: GoogleFonts.inter(
//             color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         backgroundColor: AppTemplate.bgClr,
//         // icon: const Icon(Icons.close, color: Colors.white),
//         // iconWithDecoration: BoxDecoration(
//         //   borderRadius: BorderRadius.circular(20),
//         //   border: Border.all(color: Colors.white),
//         // ),
//       );
//       Navigator.pop(context);

//       print(body['status']);
//     } else {
//       print(body['status']);
//       print(response.reasonPhrase);
//     }
//   }
// }
