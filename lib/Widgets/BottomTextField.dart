// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TextBox {
//   static void _showModalBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20.r),
//         ),
//       ),
//       builder: (context) {
//         return Container(
//           height: 282.h,
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 5.h,
//                   width: 50.w,
//                   margin: EdgeInsets.only(bottom: 16.h),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 const TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Issue Remarks',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 4,
//                 ),
//                 SizedBox(height: 20.h),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add your create ticket logic here
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF001C63), // Background color
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 50.h,
//                       vertical: 15.h,
//                     ),
//                   ),
//                   child: Text(
//                     'Create Ticket',
//                     style: GoogleFonts.inter(
//                       fontSize: 16.sp,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
