import 'dart:io';

import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'package:geolocator/geolocator.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';

// ignore: must_be_immutable
class CustomerEditList extends ConsumerStatefulWidget {
  final List<TextEditingController>? carModelNameControllers;
  final List<TextEditingController>? carNoControllers;
  final List<TextEditingController>? carLatControllers;
  final List<TextEditingController>? carLongControllers;
  final List<TextEditingController>? carPhotosController;
  final List<File?> imageFiles;

  CustomerEditList({
    Key? key,
    required this.carModelNameControllers,
    required this.carNoControllers,
    required this.carLatControllers,
    required this.carLongControllers,
    required this.carPhotosController,
    required this.imageFiles,
  }) : super(key: key);

  @override
  ConsumerState<CustomerEditList> createState() => _CustomerEditListState();
}

class _CustomerEditListState extends ConsumerState<CustomerEditList> {
  final ScrollController _scrollController = ScrollController();

  void _addNewCard() {
    widget.carModelNameControllers!.add(TextEditingController());
    widget.carNoControllers!.add(TextEditingController());
    widget.carLatControllers!.add(TextEditingController());
    widget.carLongControllers!.add(TextEditingController());
    widget.carPhotosController!.add(TextEditingController());
    widget.imageFiles.add(null);

    ref.read(customerCardProvider.notifier).addCard();
    _scrollToBottom();
  }

  void _removeCard(int index) {
    if (widget.carModelNameControllers!.length > 1) {
      widget.carModelNameControllers![index].dispose();
      widget.carNoControllers![index].dispose();
      widget.carModelNameControllers!.removeAt(index);
      widget.carNoControllers!.removeAt(index);
      ref.read(customerCardProvider.notifier).removeCard(index);
      _scrollUp();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            "At least one car must be present",
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }
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

  Future<void> _pickImage(BuildContext context, int index) async {
    print('_pickImage called for index $index');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print('Picked image path: ${pickedFile.path}'); // Debugging line

      setState(() {
        if (index < widget.imageFiles.length) {
          widget.imageFiles[index] = file;
        } else {
          // In case index is out of bounds, add a new entry
          widget.imageFiles.add(file);
        }
        // Optionally update the corresponding text controller
        widget.carPhotosController![index].text = pickedFile.path;
        print(
            'Updated carPhotosController[$index] with path: ${widget.carPhotosController![index].text}'); // Debugging line
      });
    } else {
      print('No image picked');
    }
  }

  static void _showLocationDialog(
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

  static void _showPermissionDeniedDialog(BuildContext context) {
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

  Future<void> _getLocation(BuildContext context, int index) async {
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

    setState(() {
      if (index < widget.carLatControllers!.length) {
        widget.carLatControllers![index].text = position.latitude.toString();
      } else {
        widget.carLatControllers!
            .add(TextEditingController(text: position.latitude.toString()));
      }
      if (index < widget.carLongControllers!.length) {
        widget.carLongControllers![index].text = position.longitude.toString();
      } else {
        widget.carLongControllers!
            .add(TextEditingController(text: position.longitude.toString()));
      }
    });

    print(
        'Updated location for index $index: Lat: ${position.latitude}, Long: ${position.longitude}');
    _showLocationDialog(context, position.latitude, position.longitude);
  }

  Widget imagePreview(File? imageFile, String? imageUrl) {
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: Image.file(
          imageFile,
          height: 78.h,
          width: 120.w,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: Image.network(
          imageUrl,
          height: 78.h,
          width: 120.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/Camera.svg'),
                Text(
                  'Car Picture',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF6750A4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/Camera.svg'),
          Text(
            'Car Picture',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF6750A4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.carModelNameControllers!.length,
      itemBuilder: (context, index) {
        print('Building CreateCustomerCard widget at index $index');
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Textfieldwidget(
                          controller: widget.carModelNameControllers![index],
                          labelTxt: 'Car Model',
                          labelTxtClr: const Color(0xFF929292),
                          enabledBorderClr: const Color(0xFFD4D4D4),
                          focusedBorderClr: const Color(0xFFD4D4D4),
                        ),
                        SizedBox(height: 25.h),
                        Textfieldwidget(
                          controller: widget.carNoControllers![index],
                          labelTxt: 'Vehicle No',
                          labelTxtClr: const Color(0xFF929292),
                          enabledBorderClr: const Color(0xFFD4D4D4),
                          focusedBorderClr: const Color(0xFFD4D4D4),
                        ),
                        SizedBox(height: 25.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (widget.carPhotosController![index].text
                                        .isEmpty) {
                                      await _pickImage(context, index);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 130.w,
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
                                        child: imagePreview(
                                          widget.imageFiles[
                                              index], // Pass the specific image file for this card
                                          widget
                                              .carPhotosController![index].text,
                                        ), // Pass URL for preview
                                      ),
                                    ),
                                  ),
                                ),
                                widget.carPhotosController![index].text
                                        .isNotEmpty
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.carPhotosController![index]
                                                      .text =
                                                  ''; // Clear the URL if needed
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
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/close.svg',
                                                color: Color(0xFFFF0000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _requestPermissions();
                                await _getLocation(context, index);
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Container(
                                      height: 80.h,
                                      width: 110.w,
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
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/map.jpeg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 20.h,
                                      left: 37.w,
                                      child: SvgPicture.asset(
                                        'assets/svg/Map pin.svg',
                                        color: Color(0xFF447B00),
                                      )),
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
                  onTap: () => setState(() {
                    _removeCard(
                      index,
                    );
                  }),
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
      },
    );
  }
}
