import 'dart:convert';

import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Customer/createCustomer.dart';
import 'package:car_wash/pages/Customer/createProfile.dart';
import 'package:car_wash/utils/constants.dart';
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

  @override
  void initState() {
    super.initState();
    customerList();

    // Add listener to searchController
    searchController.addListener(() {
      filterCustomerList();
    });
  }

  @override
  void dispose() {
    // Dispose the controller
    searchController.dispose();
    super.dispose();
  }

  String? customerId;
  List<dynamic> body = [];
  List<dynamic> filteredBody = [];
  var responseBody;

  Future<void> customerList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-List'),
      );
      request.fields.addAll({
        'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
        'emp_id': '123',
        'search_name': searchController.text
      });

      http.StreamedResponse response = await request.send();
      String temp = await response.stream.bytesToString();
      responseBody = jsonDecode(temp);

      if (response.statusCode == 200) {
        setState(() {
          body = responseBody['data'] ?? [];
          filteredBody = body;
          isLoading = false;
        });
        print('Search results: ${body.length}');
      } else {
        setState(() {
          body = [];
          filteredBody = [];
          isLoading = false;
        });
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        body = [];
        filteredBody = [];
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  void filterCustomerList() {
    setState(() {
      filteredBody = body.where((customer) {
        final name = customer['client_name']?.toLowerCase() ?? '';
        final search = searchController.text.toLowerCase();
        return name.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          children: [
            const Header(txt: 'Customer'),
            SizedBox(
              height: 20.h,
            ),
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
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
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
            SizedBox(
              height: 20.h,
            ),
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
                  isLoading
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
                          'Showing ${filteredBody.length} results',
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                ],
              ),
            ),
            filteredBody.isEmpty && !isLoading
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredBody.length,
                      itemBuilder: (context, index) {
                        var employee = filteredBody[index];
                        customerId = employee['customer_id'];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (employee['client_name'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomerProfile(
                                          customerName:
                                              employee['client_name'] ?? '',
                                          customerId: employee['customer_id'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    print("Customer name is null");
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
                                            employee['client_name'] ?? '',
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
                              SizedBox(
                                height: 25.h,
                              )
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
