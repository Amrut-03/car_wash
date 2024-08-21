import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/customer/model/wash_info_model.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class CarWashedDetails extends ConsumerStatefulWidget {
  const CarWashedDetails({super.key, required this.washId});
  final String washId;

  @override
  ConsumerState<CarWashedDetails> createState() => _CarWashedDetailsState();
}

class _CarWashedDetailsState extends ConsumerState<CarWashedDetails> {
  WashResponse? washResponse;
  List<CleanedPhoto> beforeWashPhotos = [];
  List<CleanedPhoto> afterWashPhotos = [];
  TextEditingController issueController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchWashInfo();
  }

  Future<void> fetchWashInfo() async {
    const url = 'https://wash.sortbe.com/API/Admin/Client/Wash-Information';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'wash_id': widget.washId,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        setState(() {
          washResponse = WashResponse.fromJson(responseData);
          beforeWashPhotos = washResponse!.cleanedPhotos
              .where((photo) => photo.cleanDuration == 'Before')
              .toList();
          afterWashPhotos = washResponse!.cleanedPhotos
              .where((photo) => photo.cleanDuration == 'After')
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    }
  }

  Future<void> createTicket() async {
    const url = 'https://wash.sortbe.com/API/Admin/Client/Ticket-Creation';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'wash_id': widget.washId,
          'remarks': issueController.text,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              'Ticket Created Successfully',
              style: GoogleFonts.inter(
                color: AppTemplate.primaryClr,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    }
  }

  Future<void> closeTicket(String ticketId) async {
    const url = 'https://wash.sortbe.com/API/Admin/Client/Ticket-Close';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'ticket_id': ticketId,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              'Ticket Resolved Successfully',
              style: GoogleFonts.inter(
                color: AppTemplate.primaryClr,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    }
  }

  Future<File?> downloadAndSaveImageToCustomDirectory(
      String url, String fileName) async {
    // Request storage permissions
    if (await Permission.storage.request().isGranted) {
      // Step 1: Download the image from the URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Step 2: Define the custom directory path in public storage
        final Directory customDirectory =
            Directory('/storage/emulated/0/Pictures/Car');

        // Step 3: Create the directory if it doesn't exist
        if (!await customDirectory.exists()) {
          await customDirectory.create(recursive: true);
        }

        // Step 4: Create the full file path in the custom directory
        final String filePath =
            path.join(customDirectory.path, '$fileName.jpg');

        // Step 5: Save the image to the specified path
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return file;
      } else {
        throw Exception('Failed to download image');
      }
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  Future<void> _shareToWhatsApp(String url, String fileName, String msg) async {
    String phoneNumber = "91+${washResponse!.mobileNo}";
    String message = msg;

    print("+++++++++++++");
    print(message);
    print("+++++++++++++");

    final response = await http.get(Uri.parse(url));

    final Directory customDirectory =
        Directory('/storage/emulated/0/Pictures/Car');

    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    final String filePath = path.join(customDirectory.path, '$fileName.jpg');

    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    if (phoneNumber.isNotEmpty) {
      final String whatsappUrl =
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
        await Share.shareXFiles([XFile(filePath)]);

        print("Success");
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image and enter a phone number.'),
        ),
      );
    }
  }

  // Future<void> shareFile(String url, String fileName) async {
  //   if (await Permission.storage.request().isGranted) {
  //     // Step 1: Download the image from the URL
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       // Step 2: Define the custom directory path in public storage
  //       final Directory customDirectory =
  //           Directory('/storage/emulated/0/Pictures/Car');

  //       // Step 3: Create the directory if it doesn't exist
  //       if (!await customDirectory.exists()) {
  //         await customDirectory.create(recursive: true);
  //       }

  //       final String filePath =
  //           path.join(customDirectory.path, '$fileName.jpg');

  //       // Step 6: Save the image to the specified path
  //       final File file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);

  //       print("+++++++++++++++++++++++");
  //       print(filePath);
  //       print("+++++++++++++++++++++++");

  //       print(washResponse!.mobileNo);

  //       await WhatsappShare.shareFile(
  //         phone:
  //             // '91${washResponse!.mobileNo}',
  //             '918111012000',
  //         filePath: [filePath],
  //       );
  //     } else {
  //       throw Exception('Failed to download image');
  //     }
  //   } else {
  //     throw Exception('Storage permission not granted');
  //   }
  // }

  // Future<void> shareImage() async {
  //   await WhatsappShare.share(phone: '919172518904',);
  // }

  // Future<void> shareFile(File _image) async {
  //   Directory? directory;
  //   if (Platform.isAndroid) {
  //     directory = await getExternalStorageDirectory();
  //   } else {
  //     directory = await getApplicationDocumentsDirectory();
  //   }
  //   debugPrint('${directory?.path} / ${_image.path}');

  //   await WhatsappShare.shareFile(
  //     phone: '911234567890',
  //     filePath: ["${_image.path}"],
  //   );
  // }

  void _showDownloadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTemplate.primaryClr,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTemplate.bgClr),
                ),
                SizedBox(height: 20),
                Text(
                  'Downloading...',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareImageOnWhatsApp(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final fileName = imageUrl.split('/').last;
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(bytes);

      final result = await WhatsappShare.shareFile(
        filePath: [file.path],
        text: 'Check out this image!',
        phone: '919172518904',
      );

      if (result == null) {
        print('Image sharing failed.');
      } else {
        print('Image shared on WhatsApp');
      }
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void showModalBottomSheetCustom(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: AppTemplate.primaryClr,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                  SizedBox(height: 15.h),
                  TextField(
                    cursorColor: const Color(0xFFD4D4D4),
                    controller: issueController,
                    decoration: InputDecoration(
                      hintText: 'Issue Remarks',
                      hintStyle:
                          GoogleFonts.inter(color: const Color(0xFF929292)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFFD4D4D4), width: 1.5.w)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFFD4D4D4), width: 1.5.w)),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      createTicket();
                      fetchWashInfo();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(227.w, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r)),
                      backgroundColor: const Color(0xFF1E3763),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 15.h,
                      ),
                    ),
                    child: Text(
                      'Create Ticket',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: washResponse == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(txt: washResponse!.clientName),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 8),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        washResponse!.clientName,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.textClr,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  washResponse!.assignedDate,
                                  style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.r),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.engineering),
                                    SizedBox(width: 8),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        washResponse!.cleanerName,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.textClr,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  washResponse!.cleanedTime,
                                  style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.r),
                            Text(
                              washResponse!.mobileNo,
                              style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF001C63)),
                            ),
                            SizedBox(
                              height: 15.r,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  washResponse!.washType,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    color: AppTemplate.textClr,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  washResponse!.washStatus,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        statusColor[washResponse!.washStatus],
                                    fontSize: 13.0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //body
                  washResponse!.washStatus == 'Cancelled'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25.w),
                              child: Text(
                                'Car Picture',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: AppTemplate.textClr,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 25.w,
                                right: 10.h,
                                bottom: 10.h,
                                top: 20.h,
                              ),
                              child: Container(
                                height: 150.h,
                                width: 220.w,
                                decoration: BoxDecoration(
                                  color: AppTemplate.primaryClr,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFE1E1E1),
                                      blurRadius: 4.r,
                                      spreadRadius: 0.r,
                                      offset: Offset(0.w, 4.h),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: const Color(0xFFE1E1E1),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: Image.network(
                                    washResponse!.cancelProof ?? '',
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w, top: 20.h),
                                  child: Text(
                                    'Cancel Reason:',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: AppTemplate.textClr,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Text(
                                    washResponse!.cancelReason ?? '',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      color: AppTemplate.textClr,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 130.h),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Before Wash',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppTemplate.textClr,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (beforeWashPhotos.isEmpty)
                              Container(
                                height: 150.h,
                                child: Center(
                                  child: Text(
                                    'Work in Progress',
                                    style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ),
                            if (beforeWashPhotos.isNotEmpty)
                              // Container(
                              //   padding: EdgeInsets.only(left: 25.w),
                              //   height: 220.h,
                              //   child: ListView.builder(
                              //     shrinkWrap: true,
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: beforeWashPhotos.length,
                              //     itemBuilder: (context, index) {
                              //       return Padding(
                              //         padding: EdgeInsets.only(
                              //           right: 10.h,
                              //           bottom: 10.h,
                              //           top: 10.h,
                              //         ),
                              //         child: Column(
                              //           children: [
                              //             Container(
                              //           height: 150.h,
                              //           width: 220.w,
                              //           decoration: BoxDecoration(
                              //             color: AppTemplate.primaryClr,
                              //             boxShadow: [
                              //               BoxShadow(
                              //                     color:
                              //                         const Color(0xFFE1E1E1),
                              //                 blurRadius: 4.r,
                              //                 spreadRadius: 0.r,
                              //                 offset: Offset(0.w, 4.h),
                              //                   ),
                              //                 ],
                              //                 borderRadius:
                              //                     BorderRadius.circular(5.r),
                              //                 border: Border.all(
                              //                   color: const Color(0xFFE1E1E1),
                              //                 ),
                              //               ),
                              //             ],
                              //             borderRadius:
                              //                 BorderRadius.circular(5.r),
                              //             border: Border.all(
                              //               color: const Color(0xFFE1E1E1),
                              //             ),
                              //           ),
                              //           child: GestureDetector(
                              //             onLongPress: () async {
                              //               // share(beforeWashPhotos[index]
                              //               //     .carImage);
                              //               // final image = await File(
                              //               //     beforeWashPhotos[index]
                              //               //         .carImage);
                              //               // shareImage(beforeWashPhotos[index]
                              //               //     .carImage);
                              //               _shareToWhatsApp(
                              //                   beforeWashPhotos[index]
                              //                       .carImage,
                              //                   "Image 18");
                              //               // shareFile(
                              //               //     beforeWashPhotos[index]
                              //               //         .carImage,
                              //               //     "Image 16");
                              //             },
                              //             onTap: () async {
                              //               final url = beforeWashPhotos[index]
                              //                   .carImage;
                              //               if (url.isNotEmpty) {
                              //                 _showDownloadingDialog(context);

                              //                 await downloadAndSaveImageToCustomDirectory(
                              //                   url,
                              //                   "Image 16",
                              //                 );

                              //                 Navigator.of(context).pop();

                              //                 ScaffoldMessenger.of(context)
                              //                     .showSnackBar(
                              //                   SnackBar(
                              //                     backgroundColor:
                              //                         AppTemplate.bgClr,
                              //                     content: Text(
                              //                       "Image saved to gallery",
                              //                       style: GoogleFonts.inter(
                              //                         color: AppTemplate
                              //                             .primaryClr,
                              //                         fontWeight:
                              //                             FontWeight.w400,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 );
                              //               } else {
                              //                 ScaffoldMessenger.of(context)
                              //                     .showSnackBar(SnackBar(
                              //                   backgroundColor:
                              //                       AppTemplate.bgClr,
                              //                   content: Text(
                              //                     "Image not available",
                              //                     style: GoogleFonts.inter(
                              //                       color:
                              //                           AppTemplate.primaryClr,
                              //                       fontWeight: FontWeight.w400,
                              //                     ),
                              //                   ),
                              //                 ));
                              //               }
                              //             },
                              //             child: ClipRRect(
                              //               borderRadius:
                              //                   BorderRadius.circular(5.r),
                              //               child: Image.network(
                              //                 beforeWashPhotos[index].carImage,
                              //                 fit: BoxFit.cover,
                              //                 errorBuilder:
                              //                     (context, error, stackTrace) {
                              //                   return Text(
                              //                       "Image not Available");
                              //                 },
                              //                 loadingBuilder: (context, child,
                              //                     loadingProgress) {
                              //                   if (loadingProgress == null) {
                              //                     return child;
                              //                   } else {
                              //                     return Center(
                              //                         child:
                              //                             CircularProgressIndicator());
                              //                   }
                              //                 },
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(5.r),
                              //                 child: Image.network(
                              //                   beforeWashPhotos[index]
                              //                       .carImage,
                              //                   fit: BoxFit.cover,
                              //                   errorBuilder: (context, error,
                              //                       stackTrace) {
                              //                     return Container(
                              //                       height: 150.h,
                              //                       width: 220.w,
                              //                       child: Center(
                              //                         child: Align(
                              //                           alignment:
                              //                               Alignment.center,
                              //                           child: Text(
                              //                             'Invalid image data',
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                             style: TextStyle(
                              //                               fontSize: 16.sp,
                              //                               fontWeight:
                              //                                   FontWeight.bold,
                              //                               color: Colors.red,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     );
                              //                   },
                              //                   loadingBuilder: (context, child,
                              //                       loadingProgress) {
                              //                     if (loadingProgress == null) {
                              //                       return child;
                              //                     } else {
                              //                       return Center(
                              //                         child:
                              //                             CircularProgressIndicator(),
                              //                       );
                              //                     }
                              //                   },
                              //                 ),
                              //               ),
                              //             ),
                              //             // SizedBox(height: 10),
                              //                   Container(
                              //                     padding: EdgeInsets.only(
                              //                         left: 10, top: 5),
                              //                     // color: Colors.amber,
                              //                     width: 220.w,
                              //                     height: 50.h,
                              //                     child: Text(
                              //                 beforeWashPhotos[index].viewName,
                              //                       style: TextStyle(
                              //                         fontSize: 16,
                              //                   fontWeight: FontWeight.bold,
                              //                       ),
                              //                       softWrap: true,
                              //                       maxLines: 2,
                              //                 overflow: TextOverflow.ellipsis,
                              //                     ),
                              //             ),
                              //           ],
                              //                   ),
                              //                 )
                              //       );
                              //     },
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.only(left: 25.w),
                                height: 220.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: beforeWashPhotos.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: 10.h,
                                        bottom: 10.h,
                                        top: 10.h,
                                      ),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onLongPress: () async {
                                              _shareToWhatsApp(
                                                  beforeWashPhotos[index]
                                                      .carImage,
                                                  "Image 18",
                                                  beforeWashPhotos[index]
                                                      .whatsapp_msg);
                                            },
                                            onTap: () async {
                                              final url =
                                                  beforeWashPhotos[index]
                                                      .carImage;
                                              if (url.isNotEmpty) {
                                                _showDownloadingDialog(context);

                                                await downloadAndSaveImageToCustomDirectory(
                                                  url,
                                                  "Image 16",
                                                );

                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        AppTemplate.bgClr,
                                                    content: Text(
                                                      "Image saved to gallery",
                                                      style: GoogleFonts.inter(
                                                        color: AppTemplate
                                                            .primaryClr,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        AppTemplate.bgClr,
                                                    content: Text(
                                                      "Image not available",
                                                      style: GoogleFonts.inter(
                                                        color: AppTemplate
                                                            .primaryClr,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 150.h,
                                              width: 220.w,
                                              decoration: BoxDecoration(
                                                color: AppTemplate.primaryClr,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFFE1E1E1),
                                                    blurRadius: 4.r,
                                                    spreadRadius: 0.r,
                                                    offset: Offset(0.w, 4.h),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE1E1E1),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                child: Image.network(
                                                  beforeWashPhotos[index]
                                                      .carImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      height: 150.h,
                                                      width: 220.w,
                                                      child: Center(
                                                        child: Text(
                                                          'Invalid image data',
                                                          textAlign:
                                                              TextAlign.center,
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
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(height: 10.h),
                                          // Container(
                                          //   padding: EdgeInsets.only(
                                          //       left: 10.w, top: 5.h),
                                          //   width: 220.w,
                                          //   height: 50.h,
                                          //   child: Text(
                                          //     beforeWashPhotos[index].viewName,
                                          //     style: TextStyle(
                                          //       fontSize: 16.sp,
                                          //       fontWeight: FontWeight.bold,
                                          //     ),
                                          //     softWrap: true,
                                          //     maxLines: 2,
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                            // SizedBox(
                            //   height: 10.h,
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'After Wash',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppTemplate.textClr,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (afterWashPhotos.isEmpty)
                              Container(
                                height: 150.h,
                                child: Center(
                                  child: Text(
                                    'Work in Progress',
                                    style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ),
                            if (beforeWashPhotos.isNotEmpty)
                              Container(
                                padding: EdgeInsets.only(left: 25.w),
                                height: 220.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: afterWashPhotos.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                          right: 10.h,
                                          bottom: 10.h,
                                          top: 10.h,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 150.h,
                                              width: 220.w,
                                              decoration: BoxDecoration(
                                                color: AppTemplate.primaryClr,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFFE1E1E1),
                                                    blurRadius: 4.r,
                                                    spreadRadius: 0.r,
                                                    offset: Offset(0.w, 4.h),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE1E1E1),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                child: Image.network(
                                                  afterWashPhotos[index]
                                                      .carImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      height: 150.h,
                                                      width: 220.w,
                                                      child: Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'Invalid image data',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 5),
                                              // color: Colors.amber,
                                              width: 220.w,
                                              height: 50.h,
                                              child: Text(
                                                afterWashPhotos[index].viewName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ));
                                  },
                                ),
                              ),
                          ],
                        ),
                  //tickets
                  washResponse!.ticket.length == 0
                      ? SizedBox()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: washResponse!.ticket.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 20.w,
                                right: 20.w,
                                bottom: 25.w,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ticket',
                                        style: GoogleFonts.inter(
                                            color: AppTemplate.textClr,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppTemplate.textClr),
                                      ),
                                      washResponse!.ticket[index].status ==
                                              'Resolved'
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.w),
                                              child: Text(
                                                washResponse!
                                                    .ticket[index].status,
                                                style: GoogleFonts.inter(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Are You Sure?',
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: AppTemplate
                                                              .textClr,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        Center(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFf1E3763),
                                                                  ),
                                                                  child: Text(
                                                                    'Yes',
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await closeTicket(washResponse!
                                                                        .ticket[
                                                                            index]
                                                                        .ticketId);
                                                                    await fetchWashInfo();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFf1E3763)),
                                                                  child: Text(
                                                                    'No',
                                                                    style: GoogleFonts.inter(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Close Ticket',
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFFC80000),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      const Color(0xFFC80000),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    washResponse!.ticket[index].ticketContent,
                                    style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                  //create ticket and send to whatsapp

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 15.w,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Buttonwidget(
                        width: 0,
                        height: 50.h,
                        buttonClr: const Color(0xFf1E3763),
                        txt: 'Raise Ticket',
                        textClr: AppTemplate.primaryClr,
                        textSz: 16.0,
                        onClick: () => showModalBottomSheetCustom(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
