// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:car_wash/common/utils/constants.dart';

// // ignore: must_be_immutable
// class CustomerListWidget extends StatefulWidget {
//   final List<TextEditingController> carModelNameControllers;
//   final List<TextEditingController> carNoControllers;
//   final List<TextEditingController> addressControllers;
//   final List<TextEditingController> carTypeControllers;
//   final List<TextEditingController> carLatControllers;
//   final List<TextEditingController> carLongControllers;
//   final List<TextEditingController> carPhotosControllers;
//   final List<File?> imageFiles;
//   final List<String> originalCarType;
//   final ScrollController scrollController;
//   final Function(BuildContext, int) onPickImage;
//   final int carModelLength;
//   final Map<String, String> carTypes;
//   WidgetRef ref;

//   CustomerListWidget({
//     Key? key,
//     required this.carModelNameControllers,
//     required this.carNoControllers,
//     required this.addressControllers,
//     required this.carTypeControllers,
//     required this.carLatControllers,
//     required this.carLongControllers,
//     required this.carPhotosControllers,
//     required this.imageFiles,
//     required this.originalCarType,
//     required this.scrollController,
//     required this.onPickImage,
//     required this.carTypes,
//     required this.ref,
//     required this.carModelLength,
//   }) : super(key: key);

//   @override
//   State<CustomerListWidget> createState() => _CustomerListWidgetState();
// }

// class _CustomerListWidgetState extends State<CustomerListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         controller: widget.scrollController,
//         itemCount: widget.carModelNameControllers.length,
//         itemBuilder: (context, index) {
//           final carModelController = widget.carModelNameControllers[index];
//           final carNoController = widget.carNoControllers[index];
//           final addressController = widget.addressControllers[index];
//           final carTypeController = widget.carTypeControllers[index];
//           final carPhotosController = widget.carTypeControllers[index];
//           bool showCloseIcon = widget.carModelNameControllers.length > 1;

//           return Stack(
//             children: [
//               Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(color: Colors.grey.shade300),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           TextField(
//                             controller: carModelController,
//                             decoration: InputDecoration(
//                               labelText: 'Car Model',
//                               labelStyle: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w400),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                             ),
//                           ),
//                           SizedBox(height: 25),
//                           TextField(
//                             controller: carNoController,
//                             decoration: InputDecoration(
//                               labelText: 'Vehicle No',
//                               labelStyle: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w400),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                             ),
//                           ),
//                           SizedBox(height: 25),
//                           TextField(
//                             controller: addressController,
//                             maxLines: 3,
//                             decoration: InputDecoration(
//                               labelText: 'Address',
//                               labelStyle: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w400),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300)),
//                             ),
//                           ),
//                           SizedBox(height: 25),
//                           Stack(
//                             children: [
//                               Container(
//                                 height: 45.h,
//                                 width: 390.w,
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                   borderRadius: BorderRadius.circular(5.r),
//                                   border: Border.all(
//                                     color: const Color(0xFFD4D4D4),
//                                     width: 1.w,
//                                   ),
//                                 ),
//                                 child: DropdownButtonFormField<String>(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   dropdownColor: AppTemplate.primaryClr,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     contentPadding:
//                                         EdgeInsets.symmetric(horizontal: 10.w),
//                                   ),
//                                   value: widget.carTypes.keys
//                                           .contains(carTypeController.text)
//                                       ? carTypeController.text
//                                       : widget.carTypes.keys.isNotEmpty
//                                           ? widget.carTypes.keys.first
//                                           : null, // Set to null if no car types are available
//                                   icon: const Icon(Icons.arrow_drop_down),
//                                   iconSize: 30,
//                                   elevation: 16,
//                                   style: const TextStyle(
//                                     color: AppTemplate.textClr,
//                                     fontSize: 15,
//                                   ),
//                                   // onChanged: (String? newValue) {
//                                   //   if (newValue != null) {
//                                   //     setState(() {
//                                   //       // Ensure that you update the correct index
//                                   //       // Make sure `currentIndex` is set correctly
//                                   //       if (index <
//                                   //           widget.originalCarType.length) {
//                                   //         widget.originalCarType[index] =
//                                   //             widget.carTypes[newValue] ?? '';
//                                   //       }
//                                   //       // Update the TextEditingController with the selected value
//                                   //       carTypeController.text =
//                                   //           widget.carTypes[newValue] ?? '';
//                                   //     });
//                                   //   }
//                                   // },
//                                   onChanged: (String? newValue) {
//                                     if (newValue != null) {
//                                       setState(() {
//                                         widget.originalCarType[index] =
//                                             newValue; // Update the original car type list
//                                         carTypeController.text =
//                                             newValue; // Update the controller with the selected value
//                                       });
//                                     }
//                                   },
//                                   items: widget.carTypes.keys.isNotEmpty
//                                       ? widget.carTypes.keys
//                                           .map<DropdownMenuItem<String>>(
//                                               (carType) {
//                                           return DropdownMenuItem<String>(
//                                             value: carType,
//                                             child: Text(carType),
//                                           );
//                                         }).toList()
//                                       : [
//                                           DropdownMenuItem<String>(
//                                             value: '',
//                                             child: Text(
//                                                 'No car type found'), // Placeholder item
//                                           ),
//                                         ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 25),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Stack(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () async {
//                                       if (widget.imageFiles[index] == null) {
//                                         await AppTemplate.pickImage(
//                                             context,
//                                             index,
//                                             widget.imageFiles,
//                                             widget.carPhotosControllers,
//                                             setState);
//                                       }
//                                     },
//                                     child: SizedBox(
//                                       width: 130.w,
//                                       height: 95.h,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             color: AppTemplate.primaryClr,
//                                             borderRadius:
//                                                 BorderRadius.circular(5.r),
//                                             border: Border.all(
//                                               color: const Color(0xFFCCC3E5),
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: AppTemplate
//                                                     .enabledBorderClr,
//                                                 offset: Offset(2.w, 4.h),
//                                                 blurRadius: 4.r,
//                                               ),
//                                             ],
//                                           ),
//                                           child: AppTemplate.imagePreview(
//                                               widget.imageFiles[index],
//                                               carPhotosController.text),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   carPhotosController.text.isNotEmpty
//                                       ? Positioned(
//                                           right: 0,
//                                           top: 0,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 // Clear the image path from the controller
//                                                 widget
//                                                     .carPhotosControllers[index]
//                                                     .text = '';

//                                                 // Remove the image file from the list
//                                                 widget.imageFiles[index] = null;
//                                               });
//                                             },
//                                             child: Container(
//                                               height: 18.h,
//                                               width: 20.w,
//                                               decoration: BoxDecoration(
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: AppTemplate
//                                                         .enabledBorderClr,
//                                                     offset: Offset(2.w, 4.h),
//                                                     blurRadius: 4.r,
//                                                   ),
//                                                 ],
//                                                 color: AppTemplate.primaryClr,
//                                                 borderRadius:
//                                                     BorderRadius.circular(10.r),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: SvgPicture.asset(
//                                                   'assets/svg/close.svg',
//                                                   color: Color(0xFFFF0000),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : Container(),
//                                 ],
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   await AppTemplate.requestPermissions();
//                                   await AppTemplate.getLocation(
//                                       context,
//                                       index,
//                                       widget.carLatControllers,
//                                       widget.carLongControllers,
//                                       AppTemplate.showPermissionDeniedDialog,
//                                       AppTemplate.showLocationDialog);
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(right: 10.w),
//                                       child: Container(
//                                         height: 80.h,
//                                         width: 110.w,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   AppTemplate.enabledBorderClr,
//                                               offset: Offset(2.w, 4.h),
//                                               blurRadius: 4.r,
//                                               spreadRadius: 2.r,
//                                             ),
//                                           ],
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(5.r),
//                                           child: const Image(
//                                             image: AssetImage(
//                                                 'assets/images/map.jpeg'),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                         top: 20.h,
//                                         left: 37.w,
//                                         child: SvgPicture.asset(
//                                           'assets/svg/Map pin.svg',
//                                           color: Color(0xFF447B00),
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               if (showCloseIcon)
//                 Positioned(
//                   right: 10.w,
//                   top: -5.h,
//                   child: GestureDetector(
//                     onTap: () => setState(() {
//                       AppTemplate.removeCard(
//                         index,
//                         widget.carModelNameControllers,
//                         widget.carNoControllers,
//                         widget.addressControllers,
//                         widget.carTypeControllers,
//                         widget.carLatControllers,
//                         widget.carLongControllers,
//                         widget.carModelLength,
//                         // widget.carModelNameControllers.length,
//                         widget.imageFiles,
//                         widget.originalCarType,
//                         widget.ref,
//                         widget.scrollController,
//                       );
//                       print("###################");
//                       print(widget.carModelLength);
//                       print("###################");
//                     }),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppTemplate.enabledBorderClr,
//                             offset: Offset(0.w, 4.h),
//                             blurRadius: 4.r,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         backgroundColor: AppTemplate.primaryClr,
//                         radius: 15.r,
//                         child: SvgPicture.asset('assets/svg/red_close.svg'),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
