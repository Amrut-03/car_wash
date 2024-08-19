import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/customer/pages/customerProfile.dart';
import 'package:car_wash/features/customer/model/car_type_model.dart';
import 'package:car_wash/features/customer/model/edit_customer_data_model.dart';
import 'package:car_wash/features/customer/widgets/car_listing_edit.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Editcustomer extends ConsumerStatefulWidget {
  const Editcustomer({
    super.key,
    required this.customerId,
    required this.customerName,
  });
  final String customerId;
  final String customerName;

  @override
  ConsumerState<Editcustomer> createState() => _EditcustomerState();
}

class _EditcustomerState extends ConsumerState<Editcustomer> {
  bool isLoading = false;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  Map<String, File> imagesMap = {};
  List<dynamic> allCars = [];
  List<int> updatedCarIndexes = [];
  ClientData? clientData;
  ResponseModel? responseModel;
  bool isDisabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCustomerDetails();
    carType();
  }

  void _updateCar(int index, dynamic updatedCar) {
    setState(() {
      List<dynamic> updatedCars = [
        ...allCars.sublist(0, index),
        updatedCar,
        ...allCars.sublist(index + 1),
      ];
      allCars = updatedCars;
      addToUpdatedList(index);
    });
  }

  void addToUpdatedList(int index) {
// if updated car index is not present, add it
    List<int> carIndexes = [...updatedCarIndexes];
    if (!carIndexes.contains(index)) {
      carIndexes.add(index);
    }
    setState(() {
      updatedCarIndexes = carIndexes;
    });
  }

  void _removeUploadedImage(int index) {
    int len = index + 1;
    String imageKey = 'car_pic$len';
    Map<String, File> imgMap = {...imagesMap};
    if (imgMap.containsKey(imageKey)) {
      imgMap.remove(imageKey);
    }
    setState(() {
      imagesMap = imgMap;
    });
  }

  void _updateImageList(int index, File image) {
    int len = index + 1;
    String imageKey = 'car_pic$len';
    Map<String, File> updatedImgMap = {...imagesMap, '$imageKey': image};
    addToUpdatedList(index);
    setState(() {
      imagesMap = updatedImgMap;
      allCars[index] = allCars[index].copyWith(carImage: imageKey);
    });
  }

  bool validateFields(
      List<dynamic> availableCarDataList, List<dynamic> newCarDataList) {
    // Check if customer name or mobile number is missing
    if (customerNameController.text.isEmpty || mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer name or mobile number is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    bool hasEmptyOrNullValue(Map<String, dynamic> carData) {
      return carData.entries.any(
        (entry) {
          print('entry = $entry');
          var value = entry.value;
          return (value == null || value.toString().isEmpty) &&
              entry.key != 'address';
        },
      );
    }

    for (var car in availableCarDataList) {
      if (hasEmptyOrNullValue(car.toJson())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('One or more fields are missing in available cars'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    for (var car in newCarDataList) {
      if (hasEmptyOrNullValue(car.toJson())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('One or more fields are missing in new cars'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> updateCustomerData() async {
    setState(() {
      isLoading = true;
    });

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Edit'),
      );

      List<dynamic> availableCarDataList = [];
      List<dynamic> newCarDataList = [];

      for (var i = 0; i < allCars.length; i++) {
        var tempCar = allCars[i];

        if (tempCar.type == 'Available' && updatedCarIndexes.contains(i)) {
          if (tempCar.status == 'Removed') {
            availableCarDataList.add(
              RemovedCar(carId: tempCar.carId, status: 'Removed'),
            );
          } else if (!imagesMap.containsKey('car_pic${i + 1}')) {
            availableCarDataList.add(
              AvailableCarWOImg(
                carId: tempCar.carId,
                modelName: tempCar.modelName,
                vehicleNo: tempCar.vehicleNo,
                address: tempCar.address,
                carType: tempCar.carType,
                latitude: tempCar.latitude,
                longitude: tempCar.longitude,
                status: tempCar.status,
                type: tempCar.type,
              ),
            );
          } else {
            availableCarDataList.add(tempCar);
          }
        } else if (tempCar.type == 'New') {
          newCarDataList.add(
            NewCar(
              carId: tempCar.carId,
              modelName: tempCar.modelName,
              vehicleNo: tempCar.vehicleNo,
              address: tempCar.address,
              carImage: tempCar.carImage,
              carType: tempCar.carType,
              latitude: tempCar.latitude,
              longitude: tempCar.longitude,
              type: tempCar.type,
            ),
          );
        }
      }
      List<dynamic> jsonList = allCars.map((car) => car.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      List<dynamic> availableList =
          availableCarDataList.map((car) => car.toJson()).toList();
      String jsonString1 = jsonEncode(availableList);
      List<dynamic> newList =
          newCarDataList.map((car) => car.toJson()).toList();
      String jsonString2 = jsonEncode(newList);

      // Print JSON string
      print('Json - $jsonString');
      print("Available - $jsonString1");
      print("New - $jsonString2");

      request.fields.addAll({
        'enc_key': encKey,
        'emp_id': authState.admin!.id,
        'customer_id': widget.customerId,
        'client_name': customerNameController.text,
        'mobile': mobileController.text,
        'car_data': jsonEncode({
          'available_car': availableCarDataList,
          'new_car': newCarDataList,
        }),
      });
      bool isValid = validateFields(availableCarDataList, newCarDataList);
      if (!isValid) {
        return;
      }
      //adding images in payload
      for (var entry in imagesMap.entries) {
        print('Key: ${entry.key}');
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          ),
        );
      }

      try {
        http.StreamedResponse response = await request.send();
        String responseBody = await response.stream.bytesToString();

        var responseData = jsonDecode(responseBody);
        if (responseData['status'] == 'Success') {
          showValidationError("Customer data updated successfully", context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerProfile(
                customerName: widget.customerName,
                customerId: widget.customerId,
              ),
            ),
          );
        } else {
          showValidationError('Error updating customer data', context);
        }
      } catch (e) {
        print('Error - $e');
        showValidationError('An error occurred. Please try again.', context);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error = $e');
    } finally {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchCustomerDetails() async {
    const url = 'https://wash.sortbe.com/API/Admin/Client/Client-View';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'customer_id': widget.customerId,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        print('data $responseData');
        print('cars ${responseData['customer_cars']}');
        if (responseData != null) {
          setState(() {
            clientData = ClientData.fromJson(responseData);
            if (responseData['customer_cars'] != null) {
              var carsJson = responseData['customer_cars'] as List;
              List<dynamic> carList = carsJson
                  .map((carJson) => AvailableCar.fromJson(carJson))
                  .toList();
              allCars = carList;
            }
            mobileController.text = clientData!.customerData.mobileNo;
            customerNameController.text = clientData!.customerData.clientName;
          });
        } else {
          throw Exception('Data field is null');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    } finally {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> carType() async {
    const url = 'https://wash.sortbe.com/API/Car-Type';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Cartype - $responseData');

      if (responseData['status'] == 'Success') {
        print('Cartypedata $responseData');
        setState(() {
          responseModel = ResponseModel.fromJson(responseData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    } finally {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _addNewCar() {
    List<dynamic> updatedCarList = [...allCars];
    updatedCarList.add(
      NewCarWithStatus(
        carId: "",
        modelName: "",
        vehicleNo: "",
        address: "",
        carType: "1",
        carImage: "",
        latitude: "",
        longitude: "",
        type: "New",
        status: 'Available',
      ),
    );

    setState(() {
      allCars = updatedCarList;
    });
  }

  // void _removeCar(int index) {
  //   // if removed car index is not present, add it
  //   setState(() {
  //     List<int> carIndexes = [...removedCarIndexes];
  //     if (!carIndexes.contains(index)) {
  //       carIndexes.add(index);
  //     }
  //     removedCarIndexes = carIndexes;
  //   });
  //   addToUpdatedList(index);
  // }

  void toggleDisable() {
    setState(() {
      if (isDisabled) {
        isDisabled = false;
      } else {
        isDisabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int carLength =
        allCars.where((element) => !(element.status == 'Removed')).length;

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
                      _addNewCar();
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
                      buttonClr:
                          isDisabled ? Colors.grey : const Color(0xFf1E3763),
                      txt: 'Update',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.0,
                      onClick: () async {
                        if (isDisabled) {
                          return;
                        }
                        await updateCustomerData();
                      },
                    ),
            ],
          ),
        ),
      ),
      body: Center(
        child: clientData == null || responseModel == null
            ? CircularProgressIndicator()
            : Column(
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Textfieldwidget(
                      controller: customerNameController,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Text(
                      'Car Listing',
                      style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  allCars.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No cars available...',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: allCars.length,
                            itemBuilder: (context, index) {
                              if (allCars[index].status == 'Removed') {
                                return Container();
                              }
                              return CarListingEdit(
                                customerCar: allCars[index],
                                index: index,
                                images: imagesMap,
                                onUpdate: _updateCar,
                                onImgRemove: _removeUploadedImage,
                                onImgUpload: _updateImageList,
                                // onCarRemove: _removeCar,
                                carTypeList: responseModel!.data,
                                onToggle: toggleDisable,
                                showCancelBtn: carLength != 1,
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
