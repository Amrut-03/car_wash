// import 'package:car_wash/features/Salary/pages/individual_salary.dart';
// import 'package:car_wash/features/Salary/pages/individual_salary_final.dart';
// import 'package:car_wash/common/utils/constants.dart';
// import 'package:car_wash/features/salary/model/employee_salary_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SalaryWidget extends StatelessWidget {
//   const SalaryWidget({
//     super.key,
//     required this.salaryData,
//   });
//   final List<SalaryData> salaryData;

//   @override
//   Widget build(BuildContext context) {
//     return salaryData.isEmpty
//         ? Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 70.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Text(
//                   'No data available',
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : Expanded(
//             child: ListView.builder(
//               itemCount: salaryData.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => IndividualSalary(employeeName: employeeName, employeePic: employeePic, address: address, phone1: phone1),
//                           ),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: AppTemplate.primaryClr,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppTemplate.shadowClr,
//                                 blurRadius: 4.r,
//                                 spreadRadius: 0.r,
//                                 offset: Offset(0.w, 4.h),
//                               ),
//                             ],
//                             borderRadius: BorderRadius.circular(10.r),
//                             border: Border.all(color: AppTemplate.shadowClr),
//                           ),
//                           child: SizedBox(
//                             height: 56.h,
//                             width: double.infinity,
//                             child: Padding(
//                               padding: EdgeInsets.all(19.w),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Month',
//                                     style: TextStyle(
//                                       fontSize: 15.sp,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   salaryData[index].salary == 'No'
//                                       ? SizedBox()
//                                       : Container(
//                                           decoration: const BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Color(0xFF447B00),
//                                           ),
//                                           child: const Icon(
//                                             Icons.done,
//                                             color: AppTemplate.primaryClr,
//                                           ),
//                                         ),
//                                   SizedBox(width: 15.w),
//                                   const Icon(Icons.chevron_right)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25.h,
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }
