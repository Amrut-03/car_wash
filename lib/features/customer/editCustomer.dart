import 'dart:convert';
import 'dart:io';

import 'package:car_wash/features/customer/customer.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class EditCustomer extends ConsumerStatefulWidget {
  String customer_id;
  EditCustomer({
    required this.customer_id,
  });

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends ConsumerState<EditCustomer> {
  TextEditingController customerController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  List<TextEditingController>? carModelNameControllers;
  List<TextEditingController>? carNoControllers;
  List<TextEditingController>? carLatControllers;
  List<TextEditingController>? carLongControllers;
  List<TextEditingController>? carPhotosController;
  List<String> existingCarIds = [];

  File? imageFile;
  double lat = 0.0;
  double long = 0.0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    customerController = TextEditingController();
    mobileController = TextEditingController();
    carModelNameControllers = [];
    carNoControllers = [];
    _loadCustomerData();
  }

  List<String> carImageUrls = [];
  List<File?> imageFiles = [];

  bool validateFields() {
    if (customerController.text.isEmpty) {
      showValidationError("Customer name is required");
      return false;
    }
    if (mobileController.text.isEmpty) {
      showValidationError("Mobile number is required");
      return false;
    }
    if (mobileController.text.length != 10) {
      showValidationError("Mobile number is invalid");
      return false;
    }
    for (int i = 0; i < carModelNameControllers!.length; i++) {
      if (carModelNameControllers![i].text.isEmpty) {
        showValidationError("Model name for car ${i + 1} is required");
        return false;
      }
      if (carNoControllers![i].text.isEmpty) {
        showValidationError("Vehicle number for car ${i + 1} is required");
        return false;
      }
      if (carPhotosController![i].text.isEmpty &&
          (imageFiles[i] == null || !imageFiles[i]!.existsSync())) {
        showValidationError("Car image for car ${i + 1} is required");
        return false;
      }
      if (carLatControllers![i].text.isEmpty ||
          carLongControllers![i].text.isEmpty) {
        showValidationError(
            "Latitude and Longitude for car ${i + 1} is required");
        return false;
      }
    }
    return true;
  }

  void showValidationError(String message) {
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

  Future<void> _loadCustomerData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final data = await fetchCustomerData(widget.customer_id);
      setState(() {
        customerController = TextEditingController(
            text: data['customer_data']['client_name'] ?? '');
        mobileController = TextEditingController(
            text: data['customer_data']['mobile_no'] ?? '');

        if (data['customer_cars'] != null) {
          existingCarIds = data['customer_cars']
              .map<String>((car) => car['car_id']?.toString() ?? '')
              .toList();

          carModelNameControllers = List.generate(
            data['customer_cars'].length,
            (index) => TextEditingController(
              text: data['customer_cars'][index]['model_name'] ?? '',
            ),
          );
          carNoControllers = List.generate(
            data['customer_cars'].length,
            (index) => TextEditingController(
              text: data['customer_cars'][index]['vehicle_no'] ?? '',
            ),
          );
          carPhotosController = List.generate(
            data['customer_cars'].length,
            (index) => TextEditingController(
                text: data['customer_cars'][index]['car_photo'] ?? ''),
          );
          carLatControllers = List.generate(
            data['customer_cars'].length,
            (index) => TextEditingController(
                text: data['customer_cars'][index]['latitude'] ?? ''),
          );
          carLongControllers = List.generate(
            data['customer_cars'].length,
            (index) => TextEditingController(
                text: data['customer_cars'][index]['longitude'] ?? ''),
          );
          imageFiles.addAll(
              List.generate(data['customer_cars'].length, (index) => null));
        } else {
          // Handle case where there are no cars
          existingCarIds = [];
          carModelNameControllers = [];
          carNoControllers = [];
          carPhotosController = [];
          carLatControllers = [];
          carLongControllers = [];
          // imageFiles = [];
        }
        print(carModelNameControllers);
        isLoading = false; // Data is loaded, so set loading to false
      });
    } catch (e) {
      print('Error loading customer data: $e');
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
    }
  }

  Future<Map<String, dynamic>> fetchCustomerData(String customerId) async {
    final admin = ref.read(authProvider);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-View'),
    );
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'customer_id': customerId,
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseString);
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  Future<void> _updateCustomerData() async {
    if (!validateFields()) {
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Edit'),
    );

    List<Map<String, dynamic>> availableCarDataList = [];
    List<Map<String, dynamic>> newCarDataList = [];

    for (int i = 0; i < carModelNameControllers!.length; i++) {
      var carData = {
        'model_name': carModelNameControllers![i].text,
        'vehicle_no': carNoControllers![i].text,
        // 'car_image':
        //     imageFiles[i] != null ? 'car_pic$i' : carPhotosController![i].text,
        'latitude': carLatControllers != null && i < carLatControllers!.length
            ? carLatControllers![i].text
            : '',
        'longitude':
            carLongControllers != null && i < carLongControllers!.length
                ? carLongControllers![i].text
                : '',
      };
      print(imageFile);

      if (i < existingCarIds.length) {
        carData['car_id'] = existingCarIds[i];
        availableCarDataList.add(carData);
      } else {
        newCarDataList.add(carData);
      }
    }

    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      if (imageFile != null && await imageFile.exists()) {
        print('Adding file for car_pic$i: ${imageFile.path}');
        request.files.add(
          await http.MultipartFile.fromPath('car_pic$i', imageFile.path),
        );
      }
    }

    print(imageFiles);

    print('Available car data list: $availableCarDataList');
    print('New car data list: $newCarDataList');
    final admin = ref.read(authProvider);

    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'customer_id': widget.customer_id,
      'client_name': customerController.text,
      'mobile': mobileController.text,
      'car_data': jsonEncode({
        'available_car': availableCarDataList,
        'new_car': newCarDataList,
      }),
    });

    print('Request fields: ${request.fields}');

    try {
      http.StreamedResponse response = await request.send();
      // String temp = await response.stream.bytesToString();
      // print(temp);
      // var body = jsonDecode(temp);
      if (response.statusCode == 200) {
        print('Customer data updated successfully');
        showValidationError("Customer data updated successfully");
        print('Available car data list: $availableCarDataList');
        print('New car data list: $newCarDataList');
        // print(body);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Customer()));
      } else {
        print(
            'Error updating customer data: ${response.statusCode} ${response.reasonPhrase}');
        showValidationError('Error updating customer data');
      }
    } catch (e) {
      print('Exception: $e');
      showValidationError('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerNotifier = ref.read(customerProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTemplate.primaryClr,
      bottomNavigationBar: BottomAppBar(
        color: AppTemplate.primaryClr,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                      size: 35.w,
                    ),
                    onPressed: () {
                      setState(() {
                        // _addNewCard();
                      });
                    }),
              ),
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
                      txt: 'Update',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () async {
                        await fetchCustomerData(widget.customer_id);
                        await _updateCustomerData();

                        customerNotifier.CustomerList();
                      },
                    ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Edit Customer'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Customer Edit',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
            carModelNameControllers!.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 140.h,
                          ),
                          Text(
                            'No Record Found',
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      // controller: _scrollController,
                      itemCount: carModelNameControllers!.length,
                      itemBuilder: (context, index) {
                        print(
                            'Building CreateCustomerCard widget at index $index');
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
                                    border: Border.all(
                                        color: const Color(0xFFD4D4D4)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Textfieldwidget(
                                          controller:
                                              carModelNameControllers![index],
                                          labelTxt: 'Car Model',
                                          labelTxtClr: const Color(0xFF929292),
                                          enabledBorderClr:
                                              const Color(0xFFD4D4D4),
                                          focusedBorderClr:
                                              const Color(0xFFD4D4D4),
                                        ),
                                        SizedBox(height: 25.h),
                                        Textfieldwidget(
                                          controller: carNoControllers![index],
                                          labelTxt: 'Vehicle No',
                                          labelTxtClr: const Color(0xFF929292),
                                          enabledBorderClr:
                                              const Color(0xFFD4D4D4),
                                          focusedBorderClr:
                                              const Color(0xFFD4D4D4),
                                        ),
                                        SizedBox(height: 25.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (carPhotosController![
                                                            index]
                                                        .text
                                                        .isEmpty) {
                                                      // await _pickImage(
                                                      //     context, index);
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    width: 130.w,
                                                    height: 95.h,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTemplate
                                                              .primaryClr,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r),
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFCCC3E5),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppTemplate
                                                                  .enabledBorderClr,
                                                              offset: Offset(
                                                                  2.w, 4.h),
                                                              blurRadius: 4.r,
                                                            ),
                                                          ],
                                                        ),
                                                        // child: imagePreview(
                                                        //   imageFiles[
                                                        //       index], // Pass the specific image file for this card
                                                        //   carPhotosController![
                                                        //           index]
                                                        //       .text,
                                                        // ), // Pass URL for preview
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                carPhotosController![index]
                                                        .text
                                                        .isNotEmpty
                                                    ? Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              carPhotosController![
                                                                          index]
                                                                      .text =
                                                                  ''; // Clear the URL if needed
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 18.h,
                                                            width: 20.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: AppTemplate
                                                                      .enabledBorderClr,
                                                                  offset:
                                                                      Offset(
                                                                          2.w,
                                                                          4.h),
                                                                  blurRadius:
                                                                      4.r,
                                                                ),
                                                              ],
                                                              color: AppTemplate
                                                                  .primaryClr,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svg/close.svg',
                                                                color: Color(
                                                                    0xFFFF0000),
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
                                                // await _requestPermissions();
                                                // await _getLocation(
                                                //     context, index);
                                              },
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.w),
                                                    child: Container(
                                                      height: 80.h,
                                                      width: 110.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppTemplate
                                                                .enabledBorderClr,
                                                            offset: Offset(
                                                                2.w, 4.h),
                                                            blurRadius: 4.r,
                                                            spreadRadius: 2.r,
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
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
                                                        color:
                                                            Color(0xFF447B00),
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
                                    // _removeCard(index);
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
          ],
        ),
      ),
    );
  }
}
