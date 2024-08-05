import 'dart:convert';
import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/Customer/createCustomer.dart';
import 'package:car_wash/features/customer/createProfile.dart';

class CustomerController extends GetxController {
  var isLoading = true.obs;
  var noRecordsFound = false.obs;
  var body = <dynamic>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    customerList();
    searchController.addListener(() {
      customerList();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> customerList() async {
    isLoading(true);
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-List'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'search_name': searchController.text
    });

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();

    try {
      var responseBody = jsonDecode(temp);

      if (response.statusCode == 200 && responseBody['status'] == 'Success') {
        body(responseBody['data'] ?? []);
        noRecordsFound(body.isEmpty);
      } else {
        print('Error: ${responseBody['remarks']}');
        body([]);
        noRecordsFound(true);
      }
    } catch (e) {
      print('Failed to decode JSON: $e');
      body([]);
      noRecordsFound(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeCustomer(BuildContext context, String customer_Id) async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Remove'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'customer_id': customer_Id,
      'password': '12345665'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      awesomeTopSnackbar(
        context,
        "Customer Removed Successfully",
        textStyle: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
        backgroundColor: AppTemplate.bgClr,
      );
      body.removeWhere((customer) => customer['customer_id'] == customer_Id);
      noRecordsFound(body.isEmpty);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> confirmRemoveCustomer(
      BuildContext context, String customer_Id) async {
    bool? shouldRemove = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTemplate.primaryClr,
          title: Text(
            'Confirm Removal',
            style: GoogleFonts.inter(color: AppTemplate.textClr),
          ),
          content: Text(
            'Are you sure you want to remove this customer?',
            style: GoogleFonts.inter(color: AppTemplate.textClr),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTemplate.bgClr),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTemplate.bgClr),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                ))
          ],
        );
      },
    );

    if (shouldRemove == true) {
      await removeCustomer(context, customer_Id);
      await customerList();
    }
  }
}

class Customer extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Customer'),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Customers',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateCustomer())),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/person.svg',
                              height: 18,
                            ),
                            Positioned(
                              right: 1.w,
                              bottom: 0.h,
                              child: SvgPicture.asset(
                                'assets/svg/add.svg',
                                height: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: customerController.searchController,
                cursorColor: AppTemplate.textClr,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: 'Search by Name or Vehicle Number',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
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
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Result',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Obx(() {
                    if (customerController.isLoading.value) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 10.h,
                              width: 10.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.w,
                                color: const Color.fromARGB(255, 0, 52, 182),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text(
                        customerController.noRecordsFound.value
                            ? 'Showing 0 of 250'
                            : 'Showing ${customerController.body.length} of 250',
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      );
                    }
                  }),
                ],
              ),
            ),
            // SizedBox(height: 20.h),
            Obx(() {
              if (customerController.body.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 52, 182),
                      ),
                    ],
                  ),
                );
              } else if (customerController.body.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        'No records found',
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                );
              } else {
                return Flexible(
                  child: ListView.builder(
                    itemCount: customerController.body.length,
                    itemBuilder: (context, index) {
                      var customer = customerController.body[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (customer['client_name'] != null) {
                                  print(customer['client_name']);
                                  print(customer['id']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerProfile(
                                        customerName: customer['client_name'],
                                        customerId: customer['id'],
                                      ),
                                    ),
                                  );
                                } else {
                                  print("Null data is there");
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppTemplate.primaryClr,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTemplate.shadowClr,
                                          blurRadius: 4.r,
                                          spreadRadius: 0.r,
                                          offset: Offset(0.w, 4.h))
                                    ],
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                        color: AppTemplate.shadowClr)),
                                child: SizedBox(
                                  height: 56.h,
                                  width: 310.w,
                                  child: Padding(
                                    padding: EdgeInsets.all(19.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          customer['client_name'] ?? '',
                                          style: GoogleFonts.inter(
                                              color: AppTemplate.textClr,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.sp),
                                        ),
                                        SvgPicture.asset(
                                            'assets/svg/forward.svg')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h)
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
