import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class CreateCustomer extends ConsumerStatefulWidget {
  const CreateCustomer({super.key});

  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends ConsumerState<CreateCustomer> {
  TextEditingController customerController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final List<TextEditingController> carModelNameControllers = [];
  final List<TextEditingController> carNoControllers = [];
  final ScrollController _scrollController = ScrollController();
  final List<File?> imageFiles = [null];
  File? imageFile;
  double lat = 0.0;
  double long = 0.0;
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    carModelNameControllers.clear();
    carNoControllers.clear();
    imageFiles.clear();
    carModelNameControllers.add(TextEditingController());
    carNoControllers.add(TextEditingController());
    imageFiles.add(null);
  }

  void _addNewCard() {
    setState(() {
      carModelNameControllers.add(TextEditingController());
      carNoControllers.add(TextEditingController());
      imageFiles.add(null);
    });
    ref.read(customerCardProvider.notifier).addCard();
    _scrollToBottom();
  }

  void _removeCard(int index) {
    if (carModelNameControllers.length > 1) {
      setState(() {
        carModelNameControllers[index].dispose();
        carNoControllers[index].dispose();
        carModelNameControllers.removeAt(index);
        carNoControllers.removeAt(index);
        imageFiles.removeAt(index);
      });
      ref.read(customerCardProvider.notifier).removeCard(index);
      _scrollUp();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppTemplate.bgClr,
        content: Text(
          "At least one car must be present",
          style: GoogleFonts.inter(
            color: AppTemplate.primaryClr,
            fontWeight: FontWeight.w400,
          ),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in carModelNameControllers) {
      controller.dispose();
    }
    for (var controller in carNoControllers) {
      controller.dispose();
    }
    carModelNameControllers.clear();
    carNoControllers.clear();
    imageFiles.clear();
    super.dispose();
  }

  Future<void> createCustomer() async {
    try {
      // Validate Customer Name and Mobile Number
      if (customerController.text.isEmpty) {
        _showErrorSnackBar("Please Enter Customer Name");
        return;
      }
      if (mobileController.text.isEmpty) {
        _showErrorSnackBar("Please Enter Mobile Number");
        return;
      }

      // Validate Car Information
      for (int i = 0; i < carModelNameControllers.length; i++) {
        if (carModelNameControllers[i].text.isEmpty) {
          _showErrorSnackBar("Car model name cannot be empty");
          return;
        }
        if (carNoControllers[i].text.isEmpty) {
          _showErrorSnackBar("Vehicle number cannot be empty");
          return;
        }
      }

      // Validate at least one image file
      bool hasImage = false;
      for (final imageFile in imageFiles) {
        if (imageFile != null && await imageFile.exists()) {
          hasImage = true;
          break;
        }
      }
      if (!hasImage) {
        _showErrorSnackBar("At least one car image must be provided");
        return;
      }

      // Validate Latitude and Longitude
      if (lat == null || long == null) {
        _showErrorSnackBar("Location coordinates (lat/long) cannot be null");
        return;
      }
      if (lat < -90 || lat > 90) {
        _showErrorSnackBar("Latitude must be between -90 and 90");
        return;
      }
      if (long < -180 || long > 180) {
        _showErrorSnackBar("Longitude must be between -180 and 180");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Creation'),
      );

      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        if (imageFile != null && await imageFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('car_pic$i', imageFile.path),
          );
        } else {
          _showErrorSnackBar(
              "No image file to upload or file doesn't exist at index $i");
        }
      }

      List<Map<String, dynamic>> carInfoList = [];
      for (int i = 0; i < carModelNameControllers.length; i++) {
        carInfoList.add({
          'model_name': carModelNameControllers[i].text,
          'vehicle_no': carNoControllers[i].text,
          'lat': lat.toString(),
          'long': long.toString(),
        });
      }

      // Add other fields to the request
      request.fields.addAll({
        'enc_key': encKey,
        'emp_id': '123',
        'client_name': customerController.text,
        'mobile': mobileController.text,
        'car_info': carInfoList.toString(),
      });

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _showErrorSnackBar("Employee Account Created Successfully");
      } else {
        _showErrorSnackBar(response.reasonPhrase.toString());
      }
    } catch (e) {
      _showErrorSnackBar('Error creating customer: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppTemplate.bgClr,
      content: Text(
        message,
        style: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
      ),
    ));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollUp() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.pixels - 150.h,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  Future<void> _requestPermissions() async {
    var status = await perm_handler.Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      if (await perm_handler.Permission.locationWhenInUse.request().isGranted) {
        print('Location permission granted');
      } else {
        print('Location permission denied');
      }
    } else if (status.isGranted) {
      print('Location permission already granted');
    }
  }

  Future<void> _getLocation(BuildContext context) async {
    bool serviceEnabled;
    perm_handler.PermissionStatus permissionGranted;
    Position position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (!await Geolocator.isLocationServiceEnabled()) {
        return;
      }
    }

    permissionGranted = await perm_handler.Permission.locationWhenInUse.status;
    if (permissionGranted == perm_handler.PermissionStatus.denied) {
      permissionGranted =
          await perm_handler.Permission.locationWhenInUse.request();
      if (permissionGranted != perm_handler.PermissionStatus.granted) {
        _showPermissionDeniedDialog(context);
        return;
      }
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    ref.read(locationProvider.notifier).updateLocation(position);
    print(
        'Current location: Lat: ${position.latitude}, Long: ${position.longitude}');
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    _showLocationDialog(context, position.latitude, position.longitude);
  }

  void _showLocationDialog(
      BuildContext context, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Location Retrieved',
            style: GoogleFonts.inter(
                color: AppTemplate.textClr,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Your Live location is stored.',
            style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTemplate.textClr,
                fontWeight: FontWeight.w500),
          ),
          // Text('Lat: $latitude, Long: $longitude'),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFf1E3763)),
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Location Permission Required',
            style: GoogleFonts.inter(
                color: AppTemplate.textClr,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Please grant location permission to use this feature.',
            style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTemplate.textClr,
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFf1E3763)),
              child: Text(
                'OK',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        imageFiles[index] = file;
      });
    } else {
      print('No image picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerCards = ref.watch(customerCardProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Create Customer'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Customer Creation',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Textfieldwidget(
                controller: customerController,
                labelTxt: 'Customer Name',
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
                keyboardType: TextInputType.phone,
                controller: mobileController,
                cursorColor: AppTemplate.enabledBorderClr,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF929292),
                      fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide:
                        BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide:
                        BorderSide(color: AppTemplate.shadowClr, width: 1.5.w),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Car Listing',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: carModelNameControllers.length,
                itemBuilder: (context, index) {
                  final carModelController = carModelNameControllers[index];
                  final carNoController = carNoControllers[index];
                  final imageFile = imageFiles[index];

                  return Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.w, vertical: 10.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              borderRadius: BorderRadius.circular(5.r),
                              border:
                                  Border.all(color: const Color(0xFFD4D4D4)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4D4D4),
                                  blurRadius: 4.r,
                                  spreadRadius: 2.r,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 25.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Textfieldwidget(
                                    controller: carModelController,
                                    labelTxt: 'Car Model',
                                    labelTxtClr: const Color(0xFF929292),
                                    enabledBorderClr: const Color(0xFFD4D4D4),
                                    focusedBorderClr: const Color(0xFFD4D4D4),
                                  ),
                                  SizedBox(height: 25.h),
                                  Textfieldwidget(
                                    controller: carNoController,
                                    labelTxt: 'Vehicle No',
                                    labelTxtClr: const Color(0xFF929292),
                                    enabledBorderClr: const Color(0xFFD4D4D4),
                                    focusedBorderClr: const Color(0xFFD4D4D4),
                                  ),
                                  SizedBox(height: 25.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _pickImage(context, index),
                                        child: Container(
                                          width: 120.w,
                                          height: 80.h,
                                          decoration: BoxDecoration(
                                            color: AppTemplate.primaryClr,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            border: Border.all(
                                                color: const Color(0xFFCCC3E5)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTemplate
                                                    .enabledBorderClr,
                                                offset: Offset(2.w, 4.h),
                                                blurRadius: 4.r,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              imageFile != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      child: Image.file(
                                                        imageFile,
                                                        height: 78.h,
                                                        width: 120.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'assets/images/Camera.png',
                                                      height: 45.w,
                                                      width: double.infinity,
                                                    ),
                                              if (imageFile == null)
                                                Text(
                                                  'Car Picture',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.sp,
                                                    color:
                                                        const Color(0xFF6750A4),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await _requestPermissions();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      AppTemplate.bgClr,
                                                  content: Text(
                                                    "Please wait..!",
                                                    style: GoogleFonts.inter(
                                                        color: AppTemplate
                                                            .primaryClr,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )));
                                          await _getLocation(context);
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 80.h,
                                              width: 120.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTemplate
                                                        .enabledBorderClr,
                                                    offset: Offset(2.w, 4.h),
                                                    blurRadius: 4.r,
                                                    spreadRadius: 2.r,
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                child: const Image(
                                                  image: AssetImage(
                                                      'assets/images/map.jpeg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 20.h,
                                              left: 37.w,
                                              child: Image(
                                                image: const AssetImage(
                                                    'assets/images/Map pin.png'),
                                                height: 45.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index != 0)
                        Positioned(
                          right: 10.w,
                          top: -5.h,
                          child: GestureDetector(
                            onTap: () => _removeCard(index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTemplate.enabledBorderClr,
                                    offset: Offset(0.w, 4.h),
                                    blurRadius: 4.r,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: AppTemplate.primaryClr,
                                radius: 15.r,
                                child: SvgPicture.asset(
                                    'assets/svg/red_close.svg'),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 69.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: const Color(0xFf1E3763),
                        width: 1.5.w,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: const Color(0xFf1E3763),
                        size: 40.w,
                      ),
                      onPressed: _addNewCard,
                    ),
                  ),
                  Buttonwidget(
                    width: 227.w,
                    height: 50.h,
                    buttonClr: const Color(0xFf1E3763),
                    txt: 'Create',
                    textClr: AppTemplate.primaryClr,
                    textSz: 18.sp,
                    onClick: () async {
                      await createCustomer();
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
