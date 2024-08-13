import 'dart:io';

import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppTemplate {
  static const Color textClr = Colors.black;
  static const Color primaryClr = Colors.white;
  static const Color enabledBorderClr = Color(0xFF9B9B9B);
  static const Color buttonClr = Color(0xFF1E3763);
  static const Color bgClr = Color(0xFF021649);
  static const Color shadowClr = Color(0xFFE1E1E1);

  // static void addNewCard(
  //     List<TextEditingController>? carModelNameControllers,
  //     List<TextEditingController>? carNoControllers,
  //     List<TextEditingController>? carLatControllers,
  //     List<TextEditingController>? carLongControllers,
  //     List<TextEditingController>? carPhotosController,
  //     List<TextEditingController>? addressControllers,
  //     List<TextEditingController> carTypeControllers,
  //     int length,
  //     List<File?> imageFiles,
  //     List<String> originalCarType,
  //     ScrollController scrollController,
  //     WidgetRef ref) {
  //   carModelNameControllers!.add(TextEditingController());
  //   carNoControllers!.add(TextEditingController());
  //   carLatControllers!.add(TextEditingController());
  //   carLongControllers!.add(TextEditingController());
  //   carPhotosController!.add(TextEditingController());
  //   addressControllers!.add(TextEditingController());
  //   carTypeControllers.add(TextEditingController());

  //   imageFiles.add(null);
  //   originalCarType.add('');
  //   print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  //   length = carModelNameControllers.length;
  //   print("Car model name length :  ${carModelNameControllers.length}");
  //   print("Car model name length :  ${carModelNameControllers}");
  //   print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

  //   // Update the provider
  //   ref.read(customerCardProvider.notifier).addCard();

  //   // Scroll to the bottom
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController.hasClients) {
  //       scrollController.animateTo(
  //         scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  // static void removeCard(
  //   int index,
  //   List<TextEditingController>? carModelNameControllers,
  //   List<TextEditingController>? carNoControllers,
  //   List<TextEditingController>? addressControllers,
  //   List<TextEditingController> carTypeControllers,
  //   List<TextEditingController> carlatControllers,
  //   List<TextEditingController> carlongControllers,
  //   int length,
  //   List<File?> imageFiles,
  //   List<String> originalCarType,
  //   WidgetRef ref,
  //   ScrollController scrollController,
  // ) {
  //   if (carModelNameControllers!.length > 1) {
  //     carModelNameControllers[index].dispose();
  //     carNoControllers![index].dispose();
  //     addressControllers![index].dispose();
  //     carTypeControllers[index].dispose();
  //     carlatControllers[index].dispose();
  //     carlongControllers[index].dispose();
  //     carlatControllers.removeAt(index);
  //     carlongControllers.removeAt(index);
  //     carModelNameControllers.removeAt(index);
  //     carNoControllers.removeAt(index);
  //     addressControllers.removeAt(index);
  //     carTypeControllers.removeAt(index);

  //     imageFiles.removeAt(index);
  //     originalCarType.removeAt(index);

  //     imageFiles.add(null);
  //     length = carModelNameControllers.length;

  //     ref.read(customerCardProvider.notifier).removeCard(index);

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (scrollController.hasClients) {
  //         scrollController.animateTo(
  //           scrollController.position.pixels - 150.h,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     });
  //   }
  // }

  // static void scrollUp(ScrollController _scrollController) {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) {
  //       if (_scrollController.hasClients) {
  //         _scrollController.animateTo(
  //           _scrollController.position.pixels - 150.h,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     },
  //   );
  // }

  // static void scrollToBottom(ScrollController _scrollController) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  // static Future<void> pickImage(
  //   BuildContext context,
  //   int index,
  //   List<File?> imageFiles,
  //   List<TextEditingController> carPhotosController,
  //   Function setState,
  // ) async {
  //   print('_pickImage called for index $index');
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     final File file = File(pickedFile.path);
  //     print('Picked image path: ${pickedFile.path}');

  //     setState(() {
  //       if (index < imageFiles.length) {
  //         imageFiles[index] = file;
  //       } else {
  //         imageFiles.add(file);
  //       }

  //       carPhotosController[index].text = pickedFile.path;
  //       print(
  //           'Updated carPhotosController[$index] with path: ${carPhotosController[index].text}');
  //     });
  //   } else {
  //     print('No image picked');
  //   }
  // }

  // static void showLocationDialog(
  //     BuildContext context, double latitude, double longitude) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Location Retrieved',
  //           style: GoogleFonts.inter(
  //               color: AppTemplate.textClr,
  //               fontSize: 20.sp,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         content: Text(
  //           'Your Live location is stored.',
  //           style: GoogleFonts.inter(
  //               fontSize: 12.sp,
  //               color: AppTemplate.textClr,
  //               fontWeight: FontWeight.w500),
  //         ),
  //         actions: <Widget>[
  //           Center(
  //             child: ElevatedButton(
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
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // static void showPermissionDeniedDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Location Permission Required',
  //           style: GoogleFonts.inter(
  //               color: AppTemplate.textClr,
  //               fontSize: 20.sp,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         content: Text(
  //           'Please grant location permission to use this feature.',
  //           style: GoogleFonts.inter(
  //               fontSize: 12.sp,
  //               color: AppTemplate.textClr,
  //               fontWeight: FontWeight.w500),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFf1E3763)),
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.inter(color: Colors.white),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // static Future<void> requestPermissions() async {
  //   var status = await perm_handler.Permission.locationWhenInUse.status;
  //   if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
  //     if (await perm_handler.Permission.locationWhenInUse.request().isGranted) {
  //       print('Location permission granted');
  //     } else {
  //       print('Location permission denied');
  //     }
  //   } else if (status.isGranted) {
  //     print('Location permission already granted');
  //   }
  // }

  // static Future<void> getLocation(
  //     BuildContext context,
  //     int index,
  //     List<TextEditingController>? carLatControllers,
  //     List<TextEditingController>? carLongControllers,
  //     void Function(BuildContext) showPermissionDeniedDialog,
  //     void Function(BuildContext, double, double) showLocationDialog) async {
  //   bool serviceEnabled;
  //   perm_handler.PermissionStatus permissionGranted;
  //   Position position;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     if (!await Geolocator.isLocationServiceEnabled()) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await perm_handler.Permission.locationWhenInUse.status;
  //   if (permissionGranted == perm_handler.PermissionStatus.denied) {
  //     permissionGranted =
  //         await perm_handler.Permission.locationWhenInUse.request();
  //     if (permissionGranted != perm_handler.PermissionStatus.granted) {
  //       showPermissionDeniedDialog(context);
  //       return;
  //     }
  //   }

  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   if (index < carLatControllers!.length) {
  //     carLatControllers[index].text = position.latitude.toString();
  //   } else {
  //     carLatControllers
  //         .add(TextEditingController(text: position.latitude.toString()));
  //   }
  //   if (index < carLongControllers!.length) {
  //     carLongControllers[index].text = position.longitude.toString();
  //   } else {
  //     carLongControllers
  //         .add(TextEditingController(text: position.longitude.toString()));
  //   }

  //   print(
  //       'Updated location for index $index: Lat: ${position.latitude}, Long: ${position.longitude}');
  //   showLocationDialog(context, position.latitude, position.longitude);
  // }

  // static Widget imagePreview(File? imageFile, String? imageUrl) {
  //   if (imageFile != null) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(5.r),
  //       child: Image.file(
  //         imageFile,
  //         height: 78.h,
  //         width: 120.w,
  //         fit: BoxFit.cover,
  //       ),
  //     );
  //   } else if (imageUrl != null && imageUrl.isNotEmpty) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(5.r),
  //       child: Image.network(
  //         imageUrl,
  //         height: 78.h,
  //         width: 120.w,
  //         fit: BoxFit.cover,
  //         errorBuilder: (context, error, stackTrace) {
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset('assets/svg/Camera.svg'),
  //               Text(
  //                 'Car Picture',
  //                 style: GoogleFonts.inter(
  //                   fontSize: 12.sp,
  //                   color: const Color(0xFF6750A4),
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SvgPicture.asset('assets/svg/Camera.svg'),
  //         Text(
  //           'Car Picture',
  //           style: GoogleFonts.inter(
  //             fontSize: 12.sp,
  //             color: const Color(0xFF6750A4),
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }
}

String encKey = 'C0oRAe1QNtn3zYNvJ8rv';

String getPlannerDate(String format) {
  DateTime now = DateTime.now();
  DateTime dateToShow;

  if (now.hour < 12) {
    dateToShow = now;
  } else {
    dateToShow = now.add(Duration(days: 1));
  }

  return DateFormat(format).format(dateToShow);
}

String plannerDate1 = getPlannerDate('yyyy-MM-dd');
String plannerDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

String formattedDate1 = getPlannerDate('d MMMM yyyy');
String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

Map<String, Color> statusColor = {
  'Pending': const Color.fromRGBO(255, 195, 0, 10),
  'Completed': const Color.fromRGBO(86, 156, 0, 10),
  'Cancelled': Color.fromARGB(246, 236, 50, 72),
};

void showValidationError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppTemplate.bgClr,
      content: Text(
        message,
        style: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
