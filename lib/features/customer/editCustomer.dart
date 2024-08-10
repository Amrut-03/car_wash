import 'dart:convert';
import 'dart:io';

import 'package:car_wash/features/customer/customer.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

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
  List<TextEditingController>? addressControllers;
  List<TextEditingController> carTypeControllers = [];
  List<TextEditingController>? carLatControllers;
  List<TextEditingController>? carLongControllers;
  List<TextEditingController>? carPhotosController;
  List<String> existingCarIds = [];

  final ScrollController _scrollController = ScrollController();
  File? imageFile;
  double lat = 0.0;
  double long = 0.0;
  bool isLoading = false;
  final Map<String, String> carTypes = {
    'Hack Back': '1',
    'Sedan': '2',
    'SUV': '3',
  };
  @override
  void initState() {
    super.initState();
    customerController = TextEditingController();
    mobileController = TextEditingController();
    carModelNameControllers = [];
    carNoControllers = [];
    addressControllers = [];
    carTypeControllers = [];
    _loadCustomerData();
    print(carTypeControllers);
  }

  List<String> carImageUrls = [];
  List<File?> imageFiles = [];
  Future<void> _pickImage(BuildContext context, int index) async {
    print('_pickImage called for index $index');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print('Picked image path: ${pickedFile.path}');

      setState(() {
        if (index < imageFiles.length) {
          imageFiles[index] = file;
        } else {
          imageFiles.add(file);
        }

        carPhotosController![index].text = pickedFile.path;
        print(
            'Updated carPhotosController[$index] with path: ${carPhotosController![index].text}'); // Debugging line
      });
    } else {
      print('No image picked');
    }
  }

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
      if (carTypeControllers[i].text.isEmpty) {
        showValidationError("Car Type for car ${i + 1} is required");
        return false;
      }
      if (addressControllers![i].text.isEmpty) {
        showValidationError("Address for car ${i + 1} is required");
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

  List<Map<String, dynamic>> carTypeList = [];

  Future<void> carType() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Car-Type'),
    );
    request.fields.addAll({'enc_key': encKey});

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(temp);

    if (response.statusCode == 200) {
      carTypeList = List<Map<String, dynamic>>.from(jsonResponse['data']);
      print('Car Types: $carTypeList');
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  void initializeCarTypeControllers(List<dynamic> customerCars) {
    carTypeControllers = List.generate(
      customerCars.length,
      (index) {
        String typeId = customerCars[index]['car_type'] ?? '';
        String carType = carTypeList.firstWhere(
          (element) => element['type_id'].toString() == typeId,
          orElse: () => {'car_type': ''},
        )['car_type'] as String;
        return TextEditingController(text: carType);
      },
    );
  }

  void _onCarTypeChanged(int index, String? newValue) {
    setState(() {
      if (newValue != null) {
        carTypeControllers[index].text =
            carTypes.entries.firstWhere((entry) => entry.value == newValue).key;
      } else {
        carTypeControllers[index].text = '';
      }
    });
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

  Future<void> _loadCustomerData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await fetchCustomerData(widget.customer_id);

      if (data['customer_cars'] != null && data['customer_cars'].isNotEmpty) {
        // Initialize controllers and data
        await carType(); // Ensure carType() completes before proceeding

        // Initialize text controllers
        customerController = TextEditingController(
          text: data['customer_data']['client_name'] ?? '',
        );
        mobileController = TextEditingController(
          text: data['customer_data']['mobile_no'] ?? '',
        );

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
            text: data['customer_cars'][index]['car_photo'] ?? '',
          ),
        );
        carLatControllers = List.generate(
          data['customer_cars'].length,
          (index) => TextEditingController(
            text: data['customer_cars'][index]['latitude'] ?? '',
          ),
        );
        addressControllers = List.generate(
          data['customer_cars'].length,
          (index) => TextEditingController(
            text: data['customer_cars'][index]['address'] ?? '',
          ),
        );

        initializeCarTypeControllers(data['customer_cars']);

        carLongControllers = List.generate(
          data['customer_cars'].length,
          (index) => TextEditingController(
            text: data['customer_cars'][index]['longitude'] ?? '',
          ),
        );

        imageFiles =
            List.generate(data['customer_cars'].length, (index) => null);

        // Update state with the new data
        setState(() {
          isLoading = false;
        });
      } else {
        // Handle case where there are no cars
        setState(() {
          customerController = TextEditingController(
            text: data['customer_data']['client_name'] ?? '',
          );
          mobileController = TextEditingController(
            text: data['customer_data']['mobile_no'] ?? '',
          );

          existingCarIds = [];
          carModelNameControllers = [];
          carNoControllers = [];
          carPhotosController = [];
          carLatControllers = [];
          carLongControllers = [];
          addressControllers = [];
          carTypeControllers = [];
          imageFiles = [];

          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading customer data: $e');
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
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
        'car_image': imageFiles[i] != null
            ? 'car_pic${i}'
            : carPhotosController![i].text,
        'address': addressControllers![i].text,
        'car_type': carTypeControllers[i].text,
        'latitude': carLatControllers != null && i < carLatControllers!.length
            ? carLatControllers![i].text
            : '',
        'longitude':
            carLongControllers != null && i < carLongControllers!.length
                ? carLongControllers![i].text
                : '',
      };

      if (i < existingCarIds.length) {
        carData['car_id'] = existingCarIds[i];
        availableCarDataList.add(carData);
      } else {
        newCarDataList.add(carData);
      }
    }

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

    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      if (imageFile != null && await imageFile.exists()) {
        request.files.add(
            await http.MultipartFile.fromPath('car_pic${i}', imageFile.path));
      }
    }
    print('Request fields: ${request.fields}');
    print(
        'Request files: ${request.files.map((file) => file.filename).toList()}');

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      if (response.statusCode == 200) {
        print('Customer data updated successfully');
        showValidationError("Customer data updated successfully");
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
        isLoading = false; // Stop loading
      });
    }
  }

  void _addNewCard() {
    // Add a new controller for each property
    carModelNameControllers!.add(TextEditingController());
    carNoControllers!.add(TextEditingController());
    carLatControllers!.add(TextEditingController());
    carLongControllers!.add(TextEditingController());
    carPhotosController!.add(TextEditingController());
    addressControllers!.add(TextEditingController());
    carTypeControllers.add(TextEditingController());

    imageFiles.add(null);

    ref.read(customerCardProvider.notifier).addCard();

    _scrollToBottom();
  }

  void _removeCard(int index) {
    if (carModelNameControllers!.length > 1) {
      setState(() {
        carModelNameControllers![index].dispose();
        carNoControllers![index].dispose();
        addressControllers![index].dispose();
        carTypeControllers[index].dispose();

        carModelNameControllers!.removeAt(index);
        carNoControllers!.removeAt(index);
        addressControllers!.removeAt(index);
        carTypeControllers.removeAt(index);

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
      // Update the specific index for latitude and longitude
      if (index < carLatControllers!.length) {
        carLatControllers![index].text = position.latitude.toString();
      } else {
        carLatControllers!
            .add(TextEditingController(text: position.latitude.toString()));
      }
      if (index < carLongControllers!.length) {
        carLongControllers![index].text = position.longitude.toString();
      } else {
        carLongControllers!
            .add(TextEditingController(text: position.longitude.toString()));
      }
    });

    print(
        'Updated location for index $index: Lat: ${position.latitude}, Long: ${position.longitude}');
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

  @override
  Widget build(BuildContext context) {
    final customerNotifier = ref.read(customerProvider.notifier);
    final dashboardNotifier = ref.read(dashboardProvider.notifier);
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
                        _addNewCard();
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
                        await customerNotifier.CustomerList();
                        await dashboardNotifier.fetchDashboardData();
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
                      controller: _scrollController,
                      itemCount: carModelNameControllers!.length,
                      itemBuilder: (context, index) {
                        final carModelController =
                            carModelNameControllers![index];
                        final carNoController = carNoControllers![index];
                        final addressController =
                            addressControllers![index]; // Add this
                        final carTypeController = carTypeControllers[index];
                        print(carTypeController.text);
                        // final imageFile = imageFiles[index];
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
                                          controller: carModelController,
                                          labelTxt: 'Car Model',
                                          labelTxtClr: const Color(0xFF929292),
                                          enabledBorderClr:
                                              const Color(0xFFD4D4D4),
                                          focusedBorderClr:
                                              const Color(0xFFD4D4D4),
                                        ),
                                        SizedBox(height: 25.h),
                                        Textfieldwidget(
                                          controller: carNoController,
                                          labelTxt: 'Vehicle No',
                                          labelTxtClr: const Color(0xFF929292),
                                          enabledBorderClr:
                                              const Color(0xFFD4D4D4),
                                          focusedBorderClr:
                                              const Color(0xFFD4D4D4),
                                        ),
                                        SizedBox(height: 25.h),
                                        TextField(
                                          controller: addressController,
                                          maxLines: 3,
                                          cursorColor:
                                              AppTemplate.enabledBorderClr,
                                          decoration: InputDecoration(
                                            labelText: 'Address',
                                            labelStyle: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                color: const Color(0xFF929292),
                                                fontWeight: FontWeight.w400),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              borderSide: BorderSide(
                                                  color: AppTemplate.shadowClr,
                                                  width: 1.5.w),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              borderSide: BorderSide(
                                                  color: AppTemplate.shadowClr,
                                                  width: 1.5.w),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 25.h),
                                        // Textfieldwidget(
                                        //   controller: carTypeController,
                                        //   labelTxt: 'Car Type',
                                        //   labelTxtClr: const Color(0xFF929292),
                                        //   enabledBorderClr:
                                        //       const Color(0xFFD4D4D4),
                                        //   focusedBorderClr:
                                        //       const Color(0xFFD4D4D4),
                                        // ),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 45.h,
                                              width: 390.w,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFD4D4D4),
                                                  width: 1.w,
                                                ),
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                dropdownColor:
                                                    AppTemplate.primaryClr,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10.w),
                                                ),
                                                value: carTypes.keys.contains(
                                                        carTypeController.text)
                                                    ? carTypeController.text
                                                    : carTypes.keys.isNotEmpty
                                                        ? carTypes.keys.first
                                                        : null, // Set to null if no car types are available
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: const TextStyle(
                                                  color: AppTemplate.textClr,
                                                  fontSize: 15,
                                                ),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    setState(() {
                                                      // Update the TextEditingController with the value associated with the selected key
                                                      carTypeController.text =
                                                          carTypes[newValue] ??
                                                              '';
                                                      // Print the new value for debugging
                                                      print(
                                                          'Selected car type value: ${carTypes[newValue]}');
                                                    });
                                                  }
                                                },
                                                items: carTypes.keys.isNotEmpty
                                                    ? carTypes.keys.map<
                                                        DropdownMenuItem<
                                                            String>>((carType) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: carType,
                                                          child: Text(carType),
                                                        );
                                                      }).toList()
                                                    : [
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: '',
                                                          child: Text(
                                                              'No car type found'), // Placeholder item
                                                        ),
                                                      ],
                                              ),
                                            ),
                                          ],
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
                                                      await _pickImage(
                                                          context, index);
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
                                                        child: imagePreview(
                                                          imageFiles[
                                                              index], // Pass the specific image file for this card
                                                          carPhotosController![
                                                                  index]
                                                              .text,
                                                        ), // Pass URL for preview
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
                                                await _requestPermissions();
                                                await _getLocation(
                                                    context, index);
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
                                    _removeCard(index);
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
                        // }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
