import 'dart:io';

import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class CreateCustomerCard extends ConsumerStatefulWidget {
  final int index;
  final VoidCallback onRemove;

  const CreateCustomerCard({
    super.key,
    required this.index,
    required this.onRemove,
  });

  @override
  _CreateCustomerCardState createState() => _CreateCustomerCardState();
}

double? lat;
double? long;

class _CreateCustomerCardState extends ConsumerState<CreateCustomerCard> {
  File? imageFile;
  TextEditingController vehiclenoController = TextEditingController();
  TextEditingController carmodelController = TextEditingController();

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
    lat = position.latitude;
    long = position.longitude;

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
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Your Live location is stored.',
            style: GoogleFonts.inter(
                fontSize: 12.0,
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
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Please grant location permission to use this feature.',
            style: GoogleFonts.inter(
                fontSize: 12.0,
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

  Future<void> _pickImage(BuildContext context) async {
    print('_pickImage called');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print('Picked image path: ${pickedFile.path}');
      setState(() {
        imageFile = file;
      });
    } else {
      print('No image picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building CreateCustomerCard widget at index ${widget.index}');
    final customerCards = ref.watch(customerCardProvider);

    if (widget.index < customerCards.length &&
        customerCards[widget.index].image != null) {
      imageFile = customerCards[widget.index].image!;
      print(
          'Displaying image for card at index ${widget.index} with path: ${imageFile!.path}');
    }

    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppTemplate.primaryClr,
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(color: const Color(0xFFD4D4D4)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4D4D4),
                    blurRadius: 4.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Textfieldwidget(
                      controller: carmodelController,
                      labelTxt: 'Car Model',
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                    ),
                    SizedBox(height: 25.h),
                    Textfieldwidget(
                      controller: vehiclenoController,
                      labelTxt: 'Vehicle No',
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Container(
                            width: 120.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: const Color(0xFFCCC3E5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTemplate.enabledBorderClr,
                                  offset: Offset(2.w, 4.h),
                                  blurRadius: 4.r,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                imageFile != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        child: Image.file(
                                          imageFile!,
                                          height: 78.h,
                                          width: 120.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SvgPicture.asset('assets/svg/camera.svg'),
                                if (imageFile == null)
                                  Text(
                                    'Car Picture',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      color: const Color(0xFF6750A4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _requestPermissions();
                                await _getLocation(context);
                              },
                              child: Container(
                                height: 80.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTemplate.enabledBorderClr,
                                      offset: Offset(2.w, 4.h),
                                      blurRadius: 4.r,
                                      spreadRadius: 2.r,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: const Image(
                                    image: AssetImage('assets/images/map.jpeg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 20.h,
                                left: 37.w,
                                child:
                                    SvgPicture.asset('assets/svg/Map pin.svg')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.index != 0)
          Positioned(
            right: 10.w,
            top: -5.h,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(customerCardProvider.notifier)
                    .removeCard(widget.index - 1);
                widget.onRemove();
              },
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
                  child: SvgPicture.asset('assets/svg/red_close.svg'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
