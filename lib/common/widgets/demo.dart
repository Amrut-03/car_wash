// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import 'package:car_wash/common/utils/constants.dart';
// import 'package:car_wash/common/widgets/buttonWidget.dart';
// import 'package:car_wash/common/widgets/header.dart';
// import 'package:car_wash/common/widgets/textFieldWidget.dart';
// import 'package:car_wash/provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart' as perm_handler;

// class EditCustomer extends ConsumerStatefulWidget {
//   String customer_id;
//   EditCustomer({
//     required this.customer_id,
//   });

//   @override
//   _EditCustomerState createState() => _EditCustomerState();
// }

// class _EditCustomerState extends ConsumerState<EditCustomer> {
//   TextEditingController customerController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   List<TextEditingController>? carModelNameControllers;
//   List<TextEditingController>? carNoControllers;
//   List<TextEditingController>? carLatControllers;
//   List<TextEditingController>? carLongControllers;
//   List<TextEditingController>? carPhotosController;
//   List<String> existingCarIds = [];

//   final ScrollController _scrollController = ScrollController();
//   File? imageFile;
//   double lat = 0.0;
//   double long = 0.0;
//   @override
//   void initState() {
//     super.initState();
//     customerController = TextEditingController();
//     mobileController = TextEditingController();
//     carModelNameControllers = [];
//     carNoControllers = [];
//     _loadCustomerData();
//   }

//   // List<String> carImageUrls = [];
//   List<File?> imageFiles = [];
//   Future<void> _pickImage(BuildContext context, int index) async {
//     print('_pickImage called for index $index');
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       final File file = File(pickedFile.path);
//       print('Picked image path: ${pickedFile.path}'); // Debugging line

//       setState(() {
//         // Update the image file for the specific index
//         if (index < imageFiles.length) {
//           imageFiles[index] = file;
//         } else {
//           // In case index is out of bounds, add a new entry
//           imageFiles.add(file);
//         }
//         // Optionally update the corresponding text controller
//         carPhotosController![index].text = pickedFile.path;
//         print(
//             'Updated carPhotosController[$index] with path: ${carPhotosController![index].text}'); // Debugging line
//       });
//     } else {
//       print('No image picked');
//     }
//   }

//   Future<void> _loadCustomerData() async {
//     try {
//       final data = await fetchCustomerData(widget.customer_id);
//       setState(() {
//         customerController = TextEditingController(
//             text: data['customer_data']['client_name'] ?? '');
//         mobileController = TextEditingController(
//             text: data['customer_data']['mobile_no'] ?? '');

//         if (data['customer_cars'] != null) {
//           existingCarIds = data['customer_cars']
//               .map<String>((car) => car['car_id']?.toString() ?? '')
//               .toList();

//           carModelNameControllers = List.generate(
//             data['customer_cars'].length,
//             (index) => TextEditingController(
//               text: data['customer_cars'][index]['model_name'] ?? '',
//             ),
//           );
//           carNoControllers = List.generate(
//             data['customer_cars'].length,
//             (index) => TextEditingController(
//               text: data['customer_cars'][index]['vehicle_no'] ?? '',
//             ),
//           );
//           carPhotosController = List.generate(
//             data['customer_cars'].length,
//             (index) => TextEditingController(
//                 text: data['customer_cars'][index]['car_photo'] ?? ''),
//           );
//           carLatControllers = List.generate(
//             data['customer_cars'].length,
//             (index) => TextEditingController(
//                 text: data['customer_cars'][index]['latitude'] ?? ''),
//           );
//           carLongControllers = List.generate(
//             data['customer_cars'].length,
//             (index) => TextEditingController(
//                 text: data['customer_cars'][index]['longitude'] ?? ''),
//           );
//           imageFiles.addAll(
//               List.generate(data['customer_cars'].length, (index) => null));
//         } else {
//           // Handle case where there are no cars
//           existingCarIds = [];
//           carModelNameControllers = [];
//           carNoControllers = [];
//           carPhotosController = [];
//           carLatControllers = [];
//           carLongControllers = [];
//           imageFiles = [];
//         }

//         // isLoading = false; // Data is loaded, so set loading to false
//       });
//     } catch (e) {
//       print('Error loading customer data: $e');
//     }
//   }

//   Future<Map<String, dynamic>> fetchCustomerData(String customerId) async {
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-View'),
//     );
//     request.fields.addAll({
//       'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
//       'emp_id': '123',
//       'customer_id': customerId,
//     });

//     http.StreamedResponse response = await request.send();
//     String responseString = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       return jsonDecode(responseString);
//     } else {
//       throw Exception('Failed to load customer data');
//     }
//   }

//   Future<void> _updateCustomerData() async {
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Edit'),
//     );

//     List<Map<String, dynamic>> carDataList = [];
//     for (int i = 0; i < carModelNameControllers!.length; i++) {
//       var carData = {
//         'model_name': carModelNameControllers![i].text,
//         'vehicle_no': carNoControllers![i].text,
//         'car_image': imageFiles[i] != null && await imageFiles[i]!.exists()
//             ? 'car_pic$i' // This will be used as a key to identify the uploaded image
//             : carPhotosController![i]
//                 .text, // URL or previously uploaded image URL
//         'latitude': carLatControllers != null && i < carLatControllers!.length
//             ? carLatControllers![i].text
//             : '',
//         'longitude':
//             carLongControllers != null && i < carLongControllers!.length
//                 ? carLongControllers![i].text
//                 : '',
//         if (i < existingCarIds.length) 'car_id': existingCarIds[i],
//       };

//       carDataList.add(carData);
//       print('Car data for index $i: $carData'); // Debugging line
//     }

//     print('Car data list: $carDataList'); // Debugging line

//     for (int i = 0; i < imageFiles.length; i++) {
//       final imageFile = imageFiles[i];
//       if (imageFile != null && await imageFile.exists()) {
//         print('Adding file for car_pic$i: ${imageFile.path}'); // Debugging line
//         request.files.add(
//           await http.MultipartFile.fromPath('car_pic$i', imageFile.path),
//         );
//       }
//     }

//     request.fields.addAll({
//       'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
//       'emp_id': '123',
//       'customer_id': widget.customer_id,
//       'client_name': customerController.text,
//       'mobile': mobileController.text,
//       'car_data': jsonEncode({
//         'available_car': carDataList,
//         'new_car': "" // Add new cars here if needed
//       }),
//     });

//     print('Request fields: ${request.fields}'); // Debugging line

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       print('Customer data updated successfully');
//       Navigator.pop(context);
//     } else {
//       print(
//           'Error updating customer data: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }

//   @override
//   void dispose() {
//     customerController.dispose();
//     mobileController.dispose();
//     carModelNameControllers?.forEach((controller) => controller.dispose());
//     carPhotosController?.forEach((controller) => controller.dispose());
//     // carLatControllers?.forEach((controller) => controller.dispose());
//     // carLongControllers?.forEach((controller) => controller.dispose());
//     super.dispose();
//   }

//   void _addNewCard() {
//     carModelNameControllers!.add(TextEditingController());
//     carNoControllers!.add(TextEditingController());
//     ref.read(customerCardProvider.notifier).addCard();
//     _scrollToBottom();
//   }

//   void _removeCard(int index) {
//     if (carModelNameControllers!.length > 1) {
//       carModelNameControllers![index].dispose();
//       carNoControllers![index].dispose();
//       carModelNameControllers!.removeAt(index);
//       carNoControllers!.removeAt(index);
//       ref.read(customerCardProvider.notifier).removeCard(index);
//       _scrollUp();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: AppTemplate.bgClr,
//           content: Text(
//             "At least one car must be present",
//             style: GoogleFonts.inter(
//                 color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//           ),
//         ),
//       );
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _scrollUp() {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.pixels - 150.h,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       },
//     );
//   }

//   Future<void> _requestPermissions() async {
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
//     setState(() {
//       lat = position.latitude;
//       long = position.longitude;
//     });

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

//   @override
//   Widget build(BuildContext context) {
//     Widget imagePreview(File? imageFile, String? imageUrl) {
//       if (imageFile != null) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(5.r),
//           child: Image.file(
//             imageFile,
//             height: 78.h,
//             width: 120.w,
//             fit: BoxFit.cover,
//           ),
//         );
//       } else if (imageUrl != null && imageUrl.isNotEmpty) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(5.r),
//           child: Image.network(
//             imageUrl,
//             height: 78.h,
//             width: 120.w,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset('assets/svg/Camera.svg'),
//                   Text(
//                     'Car Picture',
//                     style: GoogleFonts.inter(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF6750A4),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       } else {
//         return Column(
//           children: [
//             SvgPicture.asset('assets/svg/Camera.svg'),
//             Text(
//               'Car Picture',
//               style: GoogleFonts.inter(
//                 fontSize: 12.sp,
//                 color: const Color(0xFF6750A4),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         );
//       }
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: AppTemplate.primaryClr,
//       bottomNavigationBar: BottomAppBar(
//         color: AppTemplate.primaryClr,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: 69.w,
//                 height: 50.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.r),
//                   border: Border.all(
//                     color: const Color(0xFf1E3763),
//                     width: 1.5.w,
//                   ),
//                 ),
//                 child: IconButton(
//                     icon: Icon(
//                       Icons.add,
//                       color: const Color(0xFf1E3763),
//                       size: 35.w,
//                     ),
//                     onPressed: () {}),
//               ),
//               // isLoading
//               //     ? SizedBox(
//               //         width: 227.w,
//               //         height: 50.h,
//               //         child: const Center(
//               //           child: CircularProgressIndicator(
//               //             color: Color.fromARGB(255, 0, 52, 182),
//               //           ),
//               //         ),
//               //       )
//               // :
//               Buttonwidget(
//                 width: 227.w,
//                 height: 50.h,
//                 buttonClr: const Color(0xFf1E3763),
//                 txt: 'Update',
//                 textClr: AppTemplate.primaryClr,
//                 textSz: 18.sp,
//                 onClick: () async {
//                   fetchCustomerData(widget.customer_id);
//                   _updateCustomerData();
//                   // Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Header(txt: 'Edit Customer'),
//             SizedBox(
//               height: 20.h,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Text(
//                 'Customer Edit',
//                 style: GoogleFonts.inter(
//                   color: AppTemplate.textClr,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Textfieldwidget(
//                 controller: customerController,
//                 labelTxt: 'Customer Name',
//                 labelTxtClr: const Color(0xFF929292),
//                 enabledBorderClr: const Color(0xFFD4D4D4),
//                 focusedBorderClr: const Color(0xFFD4D4D4),
//               ),
//             ),
//             SizedBox(
//               height: 20.h,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: TextField(
//                 keyboardType: TextInputType.phone,
//                 controller: mobileController,
//                 cursorColor: AppTemplate.enabledBorderClr,
//                 maxLength: 10,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(10),
//                 ],
//                 decoration: InputDecoration(
//                   labelText: "Mobile Number",
//                   labelStyle: GoogleFonts.inter(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF929292),
//                       fontWeight: FontWeight.w400),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.r),
//                     borderSide:
//                         BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.r),
//                     borderSide:
//                         BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: 20.h,
//             // ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Text(
//                 'Car Listing',
//                 style: GoogleFonts.inter(
//                   color: AppTemplate.textClr,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: carModelNameControllers!.length,
//                 itemBuilder: (context, index) {
//                   print('Building CreateCustomerCard widget at index $index');
//                   return Stack(
//                     children: [
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 25.w, vertical: 10.h),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: AppTemplate.primaryClr,
//                               borderRadius: BorderRadius.circular(5.r),
//                               border:
//                                   Border.all(color: const Color(0xFFD4D4D4)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFFD4D4D4),
//                                   blurRadius: 4.r,
//                                   spreadRadius: 2.r,
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 25.w, vertical: 25.h),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Textfieldwidget(
//                                     controller: carModelNameControllers![index],
//                                     labelTxt: 'Car Model',
//                                     labelTxtClr: const Color(0xFF929292),
//                                     enabledBorderClr: const Color(0xFFD4D4D4),
//                                     focusedBorderClr: const Color(0xFFD4D4D4),
//                                   ),
//                                   SizedBox(height: 25.h),
//                                   Textfieldwidget(
//                                     controller: carNoControllers![index],
//                                     labelTxt: 'Vehicle No',
//                                     labelTxtClr: const Color(0xFF929292),
//                                     enabledBorderClr: const Color(0xFFD4D4D4),
//                                     focusedBorderClr: const Color(0xFFD4D4D4),
//                                   ),
//                                   SizedBox(height: 25.h),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Stack(
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () async {
//                                               if (carPhotosController![index]
//                                                   .text
//                                                   .isEmpty) {
//                                                 await _pickImage(
//                                                     context, index);
//                                               }
//                                             },
//                                             child: SizedBox(
//                                               width: 130.w,
//                                               height: 95.h,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(10),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         AppTemplate.primaryClr,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5.r),
//                                                     border: Border.all(
//                                                       color: const Color(
//                                                           0xFFCCC3E5),
//                                                     ),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: AppTemplate
//                                                             .enabledBorderClr,
//                                                         offset:
//                                                             Offset(2.w, 4.h),
//                                                         blurRadius: 4.r,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: imagePreview(
//                                                     imageFiles[
//                                                         index], // Pass the specific image file for this card
//                                                     carPhotosController![index]
//                                                         .text,
//                                                   ), // Pass URL for preview
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           carPhotosController![index]
//                                                   .text
//                                                   .isNotEmpty
//                                               ? Positioned(
//                                                   right: 0,
//                                                   top: 0,
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         carPhotosController![
//                                                                     index]
//                                                                 .text =
//                                                             ''; // Clear the URL if needed
//                                                       });
//                                                     },
//                                                     child: Container(
//                                                       height: 18.h,
//                                                       width: 20.w,
//                                                       decoration: BoxDecoration(
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color: AppTemplate
//                                                                 .enabledBorderClr,
//                                                             offset: Offset(
//                                                                 2.w, 4.h),
//                                                             blurRadius: 4.r,
//                                                           ),
//                                                         ],
//                                                         color: AppTemplate
//                                                             .primaryClr,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10.r),
//                                                       ),
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(5.0),
//                                                         child: SvgPicture.asset(
//                                                           'assets/svg/close.svg',
//                                                           color:
//                                                               Color(0xFFFF0000),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container(),
//                                         ],
//                                       ),
//                                       Stack(
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () async {
//                                               await _requestPermissions();
//                                               await _getLocation(context);
//                                             },
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.only(right: 10.w),
//                                               child: Container(
//                                                 height: 80.h,
//                                                 width: 110.w,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: AppTemplate
//                                                           .enabledBorderClr,
//                                                       offset: Offset(2.w, 4.h),
//                                                       blurRadius: 4.r,
//                                                       spreadRadius: 2.r,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           5.r),
//                                                   child: const Image(
//                                                     image: AssetImage(
//                                                         'assets/images/map.jpeg'),
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                               top: 20.h,
//                                               left: 37.w,
//                                               child: SvgPicture.asset(
//                                                 'assets/svg/Map pin.svg',
//                                                 color: Color(0xFF447B00),
//                                               )),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (index != 0)
//                         Positioned(
//                           right: 10.w,
//                           top: -5.h,
//                           child: GestureDetector(
//                             onTap: () => _removeCard(index),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15.r),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppTemplate.enabledBorderClr,
//                                     offset: Offset(0.w, 4.h),
//                                     blurRadius: 4.r,
//                                   ),
//                                 ],
//                               ),
//                               child: CircleAvatar(
//                                 backgroundColor: AppTemplate.primaryClr,
//                                 radius: 15.r,
//                                 child: SvgPicture.asset(
//                                     'assets/svg/red_close.svg'),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Container(
//             //         width: 69.w,
//             //         height: 50.h,
//             //         decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(5.r),
//             //           border: Border.all(
//             //             color: const Color(0xFf1E3763),
//             //             width: 1.5.w,
//             //           ),
//             //         ),
//             //         child: IconButton(
//             //           icon: Icon(
//             //             Icons.add,
//             //             color: const Color(0xFf1E3763),
//             //             size: 40.w,
//             //           ),
//             //           onPressed: _addNewCard,
//             //         ),
//             //       ),
//             //       Buttonwidget(
//             //         width: 227.w,
//             //         height: 50.h,
//             //         buttonClr: const Color(0xFf1E3763),
//             //         txt: 'Update',
//             //         textClr: AppTemplate.primaryClr,
//             //         textSz: 18.sp,
//             //         onClick: () async {
//             //           // await creatCustomer();
//             //           Navigator.pop(context);
//             //         },
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
