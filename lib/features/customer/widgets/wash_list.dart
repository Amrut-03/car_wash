import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/model/wash_info_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class WashList extends StatefulWidget {
  const WashList({
    super.key,
    required this.washPhotos,
    required this.mobileNo,
    required this.listTitle,
  });
  final List<CleanedPhoto> washPhotos;
  final String mobileNo;
  final String listTitle;

  @override
  State<WashList> createState() => _WashListState();
}

class _WashListState extends State<WashList> {
  bool isLoading = false;
  Future<File?> downloadAndSaveImageToCustomDirectory(
      String url, String fileName) async {
    // Request storage permissions
    if (await Permission.manageExternalStorage.request().isGranted ||
        await Permission.storage.request().isGranted) {
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
    setState(() {
      isLoading = true; // Start loading
    });

    String phoneNumber = "+91${widget.mobileNo}";
    String message = msg;

    print("+++++++++++++");
    print(message);
    print("+++++++++++++");

    final response = await http.get(Uri.parse(url));
    print('Response = $response');

    final Directory customDirectory =
        Directory('/storage/emulated/0/Pictures/Car');

    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    final String filePath = path.join(customDirectory.path, '$fileName.jpg');

    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    if (phoneNumber.isNotEmpty) {
      print('Number = $phoneNumber');
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
    setState(() {
      isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.listTitle,
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
        widget.washPhotos.isEmpty
            ? Container(
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
              )
            : Container(
                padding: EdgeInsets.only(left: 25.w),
                height: 220.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.washPhotos.length,
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
                                  widget.washPhotos[index].carImage,
                                  "Image 18",
                                  widget.washPhotos[index].whatsapp_msg);
                            },
                            onTap: () async {
                              // Check the current permission status
                              PermissionStatus status;
                              if (Platform.isAndroid) {
                                final androidInfo =
                                    await DeviceInfoPlugin().androidInfo;
                                if (androidInfo.version.sdkInt <= 32) {
                                  status = await Permission.storage.status;
                                  print('Status = $status');
                                  if (status == PermissionStatus.denied) {
                                    print('Status2 = $status');
                                    status = await Permission.storage.request();
                                    print('Status3 = $status');
                                  }
                                } else {
                                  status = await Permission
                                      .manageExternalStorage.status;
                                  print('Status1 = $status');
                                  if (status == PermissionStatus.denied) {
                                    print('Status2 = $status');
                                    status = await Permission
                                        .manageExternalStorage
                                        .request();
                                    print('Status3 = $status');
                                  }
                                }

                                // Check the status again after requesting
                                if (status == PermissionStatus.granted) {
                                  final url = widget.washPhotos[index].carImage;
                                  if (url.isNotEmpty) {
                                    _showDownloadingDialog(context);

                                    try {
                                      await downloadAndSaveImageToCustomDirectory(
                                        url,
                                        "Image 16",
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Failed to save image: $e",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } else if (status.isPermanentlyDenied) {
                                  // If permission is permanently denied, guide the user to app settings
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTemplate.bgClr,
                                      content: Text(
                                        "Storage permission permanently denied. Please enable it in app settings.",
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.primaryClr,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );

                                  // Optionally, open app settings
                                  await openAppSettings();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTemplate.bgClr,
                                      content: Text(
                                        "Storage permission not granted.",
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.primaryClr,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
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
                              child: isLoading
                                  ? Container(
                                      height: 150.h,
                                      width: 220.w,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5.r),
                                      child: Image.network(
                                        widget.washPhotos[index].carImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 150.h,
                                            width: 220.w,
                                            child: Center(
                                              child: Text(
                                                'Failed to load',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
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
                          //SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.only(left: 10.w, top: 5.h),
                            width: 220.w,
                            height: 50.h,
                            child: Text(
                              widget.washPhotos[index].viewName,
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
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
