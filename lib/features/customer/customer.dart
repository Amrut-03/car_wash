import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/Customer/createCustomer.dart';
import 'package:car_wash/features/customer/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<dynamic> body = [];
  var responseBody;
  String? customerId;

  @override
  void initState() {
    super.initState();
    customerList();

    // Add listener to searchController
    searchController.addListener(() {
      customerList();
    });
  }

  @override
  void dispose() {
    // Dispose the controller
    searchController.dispose();
    super.dispose();
  }

  Future<void> removeCustomer() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Remove'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'customer_id': customerId!,
      'password': '12345665'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> customerList() async {
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
      responseBody = jsonDecode(temp);

      if (response.statusCode == 200 && responseBody['status'] == 'Success') {
        setState(() {
          body = responseBody['data'];
        });
      } else {
        print('Error: ${responseBody['remarks']}');
        setState(() {
          body = [];
        });
      }
    } catch (e) {
      print('Failed to decode JSON: $e');
      setState(() {
        body = [];
      });
    }
  }

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
                    child: Stack(
                      children: [
                        Image(
                          image: const AssetImage('assets/images/person.png'),
                          height: 30.h,
                        ),
                        Positioned(
                          right: 1.w,
                          bottom: 5.h,
                          child: Image(
                            image: const AssetImage('assets/images/add.png'),
                            height: 9.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: searchController,
                cursorColor: AppTemplate.textClr,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: '   Search by Name or Vehicle Number',
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
                  responseBody == null
                      ? Center(
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
                        )
                      : Text(
                          'Showing ${responseBody['data']?.length ?? 0} of 250',
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            body.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150.h,
                        ),
                        Text(
                          responseBody == null ||
                                  responseBody['data'] == null ||
                                  (responseBody['data'] as List).isEmpty
                              ? 'No records found'
                              : 'Loading...',
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      itemCount: body.length,
                      itemBuilder: (context, index) {
                        var customer = body[index];
                        customerId = customer['id'];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (customer['client_name'] != null) {
                                    print(customer['client_name']);
                                    print(customer['client_id']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomerProfile(
                                          customerName:
                                              customer['client_name'] ?? '',
                                          customerId: customerId!,
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
                                          Image(
                                            image: const AssetImage(
                                              'assets/images/forward.png',
                                            ),
                                            height: 40.h,
                                          )
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
                  ),
          ],
        ),
      ),
    );
  }
}
