import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/customer/model/car_type_model.dart';
import 'package:car_wash/features/customer/model/edit_customer_data_model.dart';
import 'package:car_wash/features/customer/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class CarListingEdit extends StatefulWidget {
  const CarListingEdit({
    super.key,
    required this.customerCar,
    required this.index,
    required this.images,
    required this.onUpdate,
    required this.onImgRemove,
    required this.onToggle,
    required this.onImgUpload,
    // required this.onCarRemove,
    required this.carTypeList,
    required this.showCancelBtn,
  });
  final dynamic customerCar;
  final int index;
  final Map<String, File> images;
  final void Function(int index, dynamic updatedCar) onUpdate;
  final void Function(int index) onImgRemove;
  // final void Function(int index) onCarRemove;
  final void Function() onToggle;
  final void Function(int index, File image) onImgUpload;
  final List<CarType> carTypeList;
  final bool showCancelBtn;

  @override
  State<CarListingEdit> createState() => _CarListingEditState();
}

class _CarListingEditState extends State<CarListingEdit> {
  final TextEditingController carModelNameController = TextEditingController();
  final TextEditingController carNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    carModelNameController.text = widget.customerCar.modelName;
    carNoController.text = widget.customerCar.vehicleNo;
    addressController.text = widget.customerCar.address;
    latController.text = widget.customerCar.latitude;
    longController.text = widget.customerCar.longitude;
    carTypeController.text = widget.customerCar.carType;
    super.initState();
  }

  void _updateCar() {
    final updatedCar = widget.customerCar.copyWith(
      modelName: carModelNameController.text,
      vehicleNo: carNoController.text,
      address: addressController.text,
      latitude: latController.text,
      longitude: longController.text,
      carType: carTypeController.text,
    );
    widget.onUpdate(widget.index, updatedCar);
  }

  
  void _removeCar() {
    final updatedCar = widget.customerCar.copyWith(
      status: "Removed",
    );
    widget.onUpdate(widget.index, updatedCar);
    widget.onImgRemove(widget.index);
  }

  void _removeImage() {
    final updatedCar = widget.customerCar.copyWith(
      carImage: "",
    );
    print('Updated car = ${updatedCar.toJson()}');
    widget.onUpdate(widget.index, updatedCar);
    widget.onImgRemove(widget.index);
  }

  Future<void> _pickImage(BuildContext context, int index) async {
    print('_pickImage called for index $index');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print('Picked image path: ${pickedFile.path}');
      widget.onImgUpload(index, file);
    } else {
      print('No image picked');
    }
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
    setState(() {
      isLoading = true;
      widget.onToggle();
    });

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      isLoading = false;
      widget.onToggle();
    });

    print('Lat: ${position.latitude}, Long: ${position.longitude}');
    _showLocationDialog(context, position.latitude, position.longitude);

    latController.text = position.latitude.toString();
    longController.text = position.longitude.toString();
    _updateCar();
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

  @override
  Widget build(BuildContext context) {
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
                      controller: carModelNameController,
                      labelTxt: 'Car Model',
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                      onChanged: (_) => _updateCar(),
                    ),
                    SizedBox(height: 25.h),
                    Textfieldwidget(
                      controller: carNoController,
                      labelTxt: 'Vehicle No',
                      labelTxtClr: const Color(0xFF929292),
                      enabledBorderClr: const Color(0xFFD4D4D4),
                      focusedBorderClr: const Color(0xFFD4D4D4),
                      onChanged: (_) => _updateCar(),
                    ),
                    SizedBox(height: 25.h),
                    TextField(
                      controller: addressController,
                      onChanged: (_) => _updateCar(),
                      maxLines: 3,
                      cursorColor: AppTemplate.enabledBorderClr,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: GoogleFonts.inter(
                            fontSize: 12.sp,
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
                    SizedBox(height: 25.h),
                    Stack(
                      children: [
                        Container(
                          height: 45.h,
                          width: 390.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: const Color(0xFFD4D4D4),
                              width: 1.w,
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(10.r),
                            dropdownColor: AppTemplate.primaryClr,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.w),
                            ),
                            value: carTypeController.text,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 16,
                            style: const TextStyle(
                              color: AppTemplate.textClr,
                              fontSize: 15,
                            ),
                            items: widget.carTypeList
                                .map<DropdownMenuItem<String>>(
                                    (CarType carType) {
                              return DropdownMenuItem<String>(
                                value: carType.typeId,
                                child: Text(carType.carType),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                carTypeController.text = value!;
                              });
                              print('Changed - ${carTypeController.text}');
                              _updateCar();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _pickImage(context, widget.index);
                              },
                              child: SizedBox(
                                width: 130.w,
                                height: 95.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
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
                                    child: imagePreview(widget.images,
                                        widget.customerCar.carImage),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _removeImage();
                                },
                                child: Container(
                                  height: 18.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTemplate.enabledBorderClr,
                                        offset: Offset(2.w, 4.h),
                                        blurRadius: 4.r,
                                      ),
                                    ],
                                    color: AppTemplate.primaryClr,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/close.svg',
                                      color: Color(0xFFFF0000),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        isLoading
                            ? Container(
                                height: 80.h,
                                width: 110.w,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await _requestPermissions();
                                  await _getLocation(context);
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: Container(
                                        height: 80.h,
                                        width: 110.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTemplate.enabledBorderClr,
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
        if (widget.showCancelBtn)
          Positioned(
            right: 10.w,
            top: -5.h,
            child: GestureDetector(
              onTap: () {
                _removeCar();
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
