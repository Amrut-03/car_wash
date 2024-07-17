// import 'dart:io';

// import 'package:car_wash/provider/provider.dart';
// import 'package:car_wash/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart' as perm_handler;

// class Location {
//   File? imageFile;

//   static Future<void> _requestPermissions() async {
//     var status = await perm_handler.Permission.locationWhenInUse.status;
//     if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
//       if (await perm_handler.Permission.locationWhenInUse.request().isGranted) {
//         print('Location permission granted');
//       } else {
//         print('Location permission denied');
//       }
//     } else if (status.isGranted) {
//       print('Location permission already granted');
//     }
//   }

//   Future<void> _pickImage(BuildContext context) async {
//     print('_pickImage called');
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       final File file = File(pickedFile.path);
//       print('Picked image path: ${pickedFile.path}');
//       setState(() {
//         imageFile = file;
//       });
//     } else {
//       print('No image picked');
//     }
//   }


//   Future<void> _getLocation(BuildContext context) async {
//     bool serviceEnabled;
//     perm_handler.PermissionStatus permissionGranted;
//     Position position;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       if (!await Geolocator.isLocationServiceEnabled()) {
//         return;
//       }
//     }

//     permissionGranted = await perm_handler.Permission.locationWhenInUse.status;
//     if (permissionGranted == perm_handler.PermissionStatus.denied) {
//       permissionGranted =
//           await perm_handler.Permission.locationWhenInUse.request();
//       if (permissionGranted != perm_handler.PermissionStatus.granted) {
//         _showPermissionDeniedDialog(context);
//         return;
//       }
//     }

//     position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     ref.read(locationProvider.notifier).updateLocation(position);
//     print(
//         'Current location: Lat: ${position.latitude}, Long: ${position.longitude}');

//     _showLocationDialog(context, position.latitude, position.longitude);
//   }

//   void _showLocationDialog(
//       BuildContext context, double latitude, double longitude) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Location Retrieved',
//             style: GoogleFonts.inter(
//                 color: AppTemplate.textClr,
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w600),
//           ),
//           content: Text(
//             'Your Live location is stored.',
//             style: GoogleFonts.inter(
//                 fontSize: 12.sp,
//                 color: AppTemplate.textClr,
//                 fontWeight: FontWeight.w500),
//           ),
//           // Text('Lat: $latitude, Long: $longitude'),
//           actions: <Widget>[
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFf1E3763)),
//                 child: Text(
//                   'OK',
//                   style: GoogleFonts.inter(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPermissionDeniedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Location Permission Required',
//             style: GoogleFonts.inter(
//                 color: AppTemplate.textClr,
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w600),
//           ),
//           content: Text(
//             'Please grant location permission to use this feature.',
//             style: GoogleFonts.inter(
//                 fontSize: 12.sp,
//                 color: AppTemplate.textClr,
//                 fontWeight: FontWeight.w500),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFf1E3763)),
//               child: Text(
//                 'OK',
//                 style: GoogleFonts.inter(color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
