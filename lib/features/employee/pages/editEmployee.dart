import 'dart:convert';
import 'dart:io';

import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditEmployee extends ConsumerStatefulWidget {
  final String empid;
  EditEmployee({
    required this.empid,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends ConsumerState<EditEmployee> {
  bool isLoading = false;
  Future<void> _pickImage(BuildContext context, WidgetRef ref,
      StateProvider<File?> imageProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      ref.read(imageProvider.notifier).state = file;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Image Uploaded Successfully",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "Image is Required",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    }
  }

  Future<void> downloadAndSaveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last;
        final file = File('${tempDir.path}/$fileName');

        await file.writeAsBytes(bytes);

        final result = await ImageGallerySaver.saveFile(file.path);

        print(result);

        if (result != null) {
          print('Image saved to gallery');
        } else {
          print('Failed to save image to gallery');
        }
      } else {
        print('Failed to download image');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print('Storage permission granted');
    } else if (status.isDenied) {
      print('Storage permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<Map<String, dynamic>?> EmployeeInfo() async {
    final admin = ref.read(authProvider);
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-View'));
      request.fields.addAll({
        'enc_key': encKey,
        'emp_id': admin.admin!.id,
        'user_id': widget.empid,
      });

      http.StreamedResponse response = await request.send();
      String temp = await response.stream.bytesToString();
      var responseBody = jsonDecode(temp);

      if (response.statusCode == 200) {
        print('Response Body: $responseBody');
        return responseBody["data"];
      } else {
        throw Exception('Failed to load employee info');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> employeeEdit(BuildContext context, WidgetRef ref) async {
    final admin = ref.read(authProvider);
    // Helper function to show snack bar
    void showValidationError(String message) {
      setState(
        () {
          isLoading = false;
        },
      );
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

    setState(() {
      isLoading = true;
    });

    final empName = ref.read(employeeNameProvider).text;
    final dob = ref.read(dobControllerProvider).text;
    final address = ref.read(addressControllerProvider).text;
    final phone1 = ref.read(phone1ControllerProvider).text;
    final phone2 = ref.read(phone2ControllerProvider).text;

    if (empName.isEmpty) {
      showValidationError("Employee name is required");
      return;
    }
    if (dob.isEmpty) {
      showValidationError("Date of Birth is required");
      return;
    }
    if (address.isEmpty) {
      showValidationError("Address is required");
      return;
    }
    if (phone1.isEmpty) {
      showValidationError("Phone number 1 is required");
      return;
    }
    if (phone2.isEmpty) {
      showValidationError("Phone number 2 is required");
      return;
    }

    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/User/Employee-Edit'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'emp_name': empName,
      'dob': dob,
      'address': address,
      'phone_1': phone1,
      'phone_2': phone2,
      'role': 'Employee',
      'user_id': widget.empid
    });

    final aadhaarFront = ref.read(aadharFrontProvider.notifier).state;
    final aadhaarFrontUrl = ref.read(aadharFrontUrlProvider.notifier).state;
    final aadhaarBack = ref.read(aadharBackProvider.notifier).state;
    final aadhaarBackUrl = ref.read(aadharBackUrlProvider.notifier).state;
    final drivingFront = ref.read(driveFrontProvider.notifier).state;
    final driveFrontUrl = ref.read(driveFrontUrlProvider.notifier).state;
    final drivingBack = ref.read(driveBackProvider.notifier).state;
    final driveBackUrl = ref.read(driveBackUrlProvider.notifier).state;
    final empPhoto = ref.read(employeePhotoProvider.notifier).state;
    final empPhotoUrl = ref.read(employeePhotoUrlProvider.notifier).state;

    Future<void> addFileToRequest(
        String fieldName, String? fileUrl, File? file) async {
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fieldName,
          file.path,
        ));
      } else if (fileUrl != null && fileUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode == 200) {
          request.files.add(http.MultipartFile.fromBytes(
            fieldName,
            response.bodyBytes,
            filename: fileUrl.split('/').last,
          ));
        } else {
          showValidationError("Error downloading file from $fileUrl");
        }
      } else {
        showValidationError("$fieldName is required");
        throw Exception("$fieldName is required");
      }
    }

    try {
      await addFileToRequest('aadhaar_front', aadhaarFrontUrl, aadhaarFront);
      await addFileToRequest('aadhaar_back', aadhaarBackUrl, aadhaarBack);
      await addFileToRequest('driving_front', driveFrontUrl, drivingFront);
      await addFileToRequest('driving_back', driveBackUrl, drivingBack);
      await addFileToRequest('emp_photo', empPhotoUrl, empPhoto);

      http.StreamedResponse response = await request.send();

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTemplate.bgClr,
            content: Text(
              "Employee Updated Successfully",
              style: GoogleFonts.inter(
                  color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
            ),
          ),
        );
        Navigator.pop(context);
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  void _showDownloadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents the dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTemplate.primaryClr,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
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
  void initState() {
    super.initState();
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var employeeData = await EmployeeInfo();

      if (employeeData != null) {
        ref.read(employeeNameProvider).text =
            employeeData['employee_name'] ?? '';
        ref.read(dobControllerProvider).text = employeeData['dob'] ?? '';
        print(employeeData['dob']);
        print(ref.read(dobControllerProvider).text);
        ref.read(addressControllerProvider).text =
            employeeData['address'] ?? '';
        ref.read(phone1ControllerProvider).text = employeeData['phone_1'] ?? '';
        ref.read(phone2ControllerProvider).text = employeeData['phone_2'] ?? '';

        ref.read(aadharFrontUrlProvider.notifier).state =
            employeeData['aadhaar_front'];
        ref.read(aadharFrontProvider.notifier).state = null;

        ref.read(aadharBackUrlProvider.notifier).state =
            employeeData['aadhaar_back'] ?? '';
        ref.read(aadharBackProvider.notifier).state = null;
        ref.read(driveFrontUrlProvider.notifier).state =
            employeeData['driving_front'] ?? '';
        ref.read(driveFrontProvider.notifier).state = null;
        ref.read(driveBackUrlProvider.notifier).state =
            employeeData['driving_back'] ?? '';
        ref.read(driveBackProvider.notifier).state = null;
        ref.read(employeePhotoUrlProvider.notifier).state =
            employeeData['employee_pic'] ?? '';
        ref.read(employeePhotoProvider.notifier).state = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardNotifier = ref.read(dashboardProvider.notifier);
    Widget imagePreview(File? imageFile, String? imageUrl) {
      if (imageFile != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5.r),
          child: Image.file(
            imageFile,
            height: 77.h,
            width: 120.w,
            fit: BoxFit.cover,
          ),
        );
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: Image.network(
              imageUrl,
              height: 77.h,
              width: 120.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SvgPicture.asset('assets/svg/Camera.svg');
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ));
      } else {
        return SvgPicture.asset('assets/svg/Camera.svg');
      }
    }

    // final employeeController = ref.read(employeeProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTemplate.primaryClr,
      body: FutureBuilder(
          future: EmployeeInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppTemplate.primaryClr,
                  color: Color.fromARGB(255, 0, 52, 182),
                ),
              );
            }
            // if (snapshot == null) {
            //   return const Center(
            //     child: CircularProgressIndicator(
            //       backgroundColor: AppTemplate.primaryClr,
            //       color: Color.fromARGB(255, 0, 52, 182),
            //     ),
            //   );
            // }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {}
            // var responseBody = snapshot.data as Map<String, dynamic>;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(txt: 'Edit Employee'),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Textfieldwidget(
                        controller: ref.read(employeeNameProvider),
                        labelTxt: "Employee Name",
                        labelTxtClr: const Color(0xFF929292),
                        enabledBorderClr: const Color(0xFFD4D4D4),
                        focusedBorderClr: const Color(0xFFD4D4D4),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: TextField(
                        controller: ref.read(dobControllerProvider),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: GoogleFonts.inter(
                              fontSize: 12.0,
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
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month,
                                color: Color(0xFFD4D4D4)),
                            onPressed: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: AppTemplate
                                          .bgClr, // header background color
                                      hintColor: AppTemplate
                                          .bgClr, // header text color
                                      colorScheme: const ColorScheme.light(
                                        primary: AppTemplate.bgClr,
                                      ), // selection color
                                      buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme
                                              .primary), // button text color
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (selectedDate != null) {
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');
                                final String formattedDate =
                                    formatter.format(selectedDate);
                                setState(() {
                                  ref.read(dobControllerProvider).text =
                                      formattedDate;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: TextField(
                        controller: ref.read(addressControllerProvider),
                        maxLines: 4,
                        cursorColor: AppTemplate.enabledBorderClr,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFF929292),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: ref.read(phone1ControllerProvider),
                        cursorColor: AppTemplate.enabledBorderClr,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: "phone 1",
                          labelStyle: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFF929292),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: ref.read(phone2ControllerProvider),
                        cursorColor: AppTemplate.enabledBorderClr,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: "phone 2",
                          labelStyle: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFF929292),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                            borderSide: BorderSide(
                                color: AppTemplate.shadowClr, width: 1.5.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text(
                        'Aadhaar Card',
                        style: GoogleFonts.inter(
                          color: AppTemplate.textClr,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url =
                                        ref.read(aadharFrontUrlProvider);

                                    if (url != null) {
                                      _showDownloadingDialog(context);

                                      await downloadAndSaveImage(url);

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Aadhaar front image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _pickImage(
                                          context, ref, aadharFrontProvider);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 140.w,
                                    height: 95.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTemplate.primaryClr,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: const Color(0xFFCCC3E5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
                                              offset: Offset(2.w, 4.h),
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            imagePreview(
                                              ref.read(aadharFrontProvider),
                                              ref.read(aadharFrontUrlProvider),
                                            ),
                                            ref.read(aadharFrontProvider) ==
                                                        null &&
                                                    ref.read(
                                                            aadharFrontUrlProvider) ==
                                                        null
                                                ? Text(
                                                    'Front Side',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color: const Color(
                                                          0xFF6750A4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ref.read(aadharFrontUrlProvider) != null ||
                                        ref.read(aadharFrontProvider) != null
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(aadharFrontUrlProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(aadharFrontProvider
                                                      .notifier)
                                                  .state = null;
                                            });
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                  ),
                                                ],
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = ref.read(aadharBackUrlProvider);

                                    if (url != null) {
                                      _showDownloadingDialog(context);

                                      await downloadAndSaveImage(url);

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Aadhaar Back image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _pickImage(
                                          context, ref, aadharBackProvider);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 140.w,
                                    height: 95.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTemplate.primaryClr,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: const Color(0xFFCCC3E5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
                                              offset: Offset(2.w, 4.h),
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            imagePreview(
                                              ref.read(aadharBackProvider),
                                              ref.read(aadharBackUrlProvider),
                                            ),
                                            ref.read(aadharBackProvider) ==
                                                        null &&
                                                    ref.read(
                                                            aadharBackUrlProvider) ==
                                                        null
                                                ? Text(
                                                    'Back Side',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color: const Color(
                                                          0xFF6750A4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ref.read(aadharBackUrlProvider) != null ||
                                        ref.read(aadharBackProvider) != null
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(aadharBackUrlProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(aadharBackProvider
                                                      .notifier)
                                                  .state = null;
                                            });
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                  ),
                                                ],
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text(
                        "Driving License",
                        style: GoogleFonts.inter(
                          color: AppTemplate.textClr,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = ref.read(driveFrontUrlProvider);

                                    if (url != null) {
                                      _showDownloadingDialog(context);

                                      await downloadAndSaveImage(url);

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Driving License front image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _pickImage(
                                          context, ref, driveFrontProvider);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 140.w,
                                    height: 95.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTemplate.primaryClr,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: const Color(0xFFCCC3E5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
                                              offset: Offset(2.w, 4.h),
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            imagePreview(
                                              ref.read(driveFrontProvider),
                                              ref.read(driveFrontUrlProvider),
                                            ),
                                            ref.read(driveFrontProvider) ==
                                                        null &&
                                                    ref.read(
                                                            driveFrontUrlProvider) ==
                                                        null
                                                ? Text(
                                                    'Front Side',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color: const Color(
                                                          0xFF6750A4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ref.read(driveFrontUrlProvider) != null ||
                                        ref.read(driveFrontProvider) != null
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(driveFrontUrlProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(driveFrontProvider
                                                      .notifier)
                                                  .state = null;
                                            });
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                  ),
                                                ],
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = ref.read(driveBackUrlProvider);

                                    if (url != null) {
                                      _showDownloadingDialog(context);

                                      await downloadAndSaveImage(url);

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Driving License Back image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _pickImage(
                                          context, ref, driveBackProvider);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 140.w,
                                    height: 95.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTemplate.primaryClr,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: const Color(0xFFCCC3E5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
                                              offset: Offset(2.w, 4.h),
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            imagePreview(
                                              ref.read(driveBackProvider),
                                              ref.read(driveBackUrlProvider),
                                            ),
                                            ref.read(driveBackProvider) ==
                                                        null &&
                                                    ref.read(
                                                            driveBackUrlProvider) ==
                                                        null
                                                ? Text(
                                                    'Back Side',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color: const Color(
                                                          0xFF6750A4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ref.read(driveBackUrlProvider) != null ||
                                        ref.read(driveBackProvider) != null
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(driveBackUrlProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(driveBackProvider
                                                      .notifier)
                                                  .state = null;
                                            });
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                  ),
                                                ],
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text(
                        'Employee Photo',
                        style: GoogleFonts.inter(
                          color: AppTemplate.textClr,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url =
                                        ref.read(employeePhotoUrlProvider);

                                    if (url != null) {
                                      _showDownloadingDialog(context);

                                      await downloadAndSaveImage(url);

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppTemplate.bgClr,
                                          content: Text(
                                            "Employee image saved to gallery",
                                            style: GoogleFonts.inter(
                                              color: AppTemplate.primaryClr,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _pickImage(
                                          context, ref, employeePhotoProvider);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 140.w,
                                    height: 95.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTemplate.primaryClr,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: const Color(0xFFCCC3E5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
                                              offset: Offset(2.w, 4.h),
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            imagePreview(
                                              ref.read(employeePhotoProvider),
                                              ref.read(
                                                  employeePhotoUrlProvider),
                                            ),
                                            ref.read(employeePhotoProvider) ==
                                                        null &&
                                                    ref.read(
                                                            employeePhotoUrlProvider) ==
                                                        null
                                                ? Text(
                                                    'Employee Photo',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color: const Color(
                                                          0xFF6750A4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ref.read(employeePhotoUrlProvider) != null ||
                                        ref.read(employeePhotoProvider) != null
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(employeePhotoUrlProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(employeePhotoProvider
                                                      .notifier)
                                                  .state = null;
                                            });
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                  ),
                                                ],
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading
                            ? SizedBox(
                                width: 227.w,
                                height: 50.h,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 0, 52, 182),
                                  ),
                                ),
                              )
                            : Buttonwidget(
                                width: 227.w,
                                height: 50.h,
                                buttonClr: const Color(0xFf1E3763),
                                txt: 'Update Employee',
                                textClr: AppTemplate.primaryClr,
                                textSz: 18.0,
                                onClick: () async {
                                  await employeeEdit(context, ref);
                                  // employeeController.fetchEmployeeList();
                                  dashboardNotifier.fetchDashboardData();
                                  print(
                                      "+++++++++++++++++++++++++++++++++++++++++++++");
                                  print(widget.empid);
                                  print(
                                      "+++++++++++++++++++++++++++++++++++++++++++++");
                                },
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
