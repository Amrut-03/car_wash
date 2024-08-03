import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/upwardMenu.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var dashboardData = {}.obs;
  var employeeCount = '0'.obs;
  var customerCount = '0'.obs;
  var washInfoList = [].obs;

  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST',
          Uri.parse('https://wash.sortbe.com/API/Admin/Dashboard/Dashboard'));
      request.fields
          .addAll({'enc_key': 'C0oRAe1QNtn3zYNvJ8rv', 'emp_id': '123'});

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);

        dashboardData.value = data;
        employeeCount.value = data['total_employee'] ?? '0';
        customerCount.value = data['total_customer'] ?? '0';
        washInfoList.value = data['wash_info'] ?? [];
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }
}

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  String name;
  String image;
  String empid;
  DashBoard({
    Key? key,
    required this.name,
    required this.image,
    required this.empid,
  }) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // Future<Map<String, dynamic>?> dashBoardData() async {
  //   try {
  //     var request = http.MultipartRequest('POST',
  //         Uri.parse('https://wash.sortbe.com/API/Admin/Dashboard/Dashboard'));
  //     request.fields
  //         .addAll({'enc_key': 'C0oRAe1QNtn3zYNvJ8rv', 'emp_id': '123'});

  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 200) {
  //       String responseBody = await response.stream.bytesToString();
  //       var data = jsonDecode(responseBody);
  //       return data;
  //     } else {
  //       print('Failed to load data: ${response.reasonPhrase}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     return null;
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Obx(
        () {
          if (dashboardController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: AppTemplate.primaryClr,
                color: Color.fromARGB(255, 0, 52, 182),
              ),
            );
          } else if (!dashboardController.dashboardData.isNotEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 180.h,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: const [
                              Color.fromARGB(255, 0, 52, 182),
                              AppTemplate.bgClr,
                              AppTemplate.bgClr,
                              AppTemplate.bgClr,
                              AppTemplate.bgClr
                            ],
                            focal: Alignment(0.8.w, -0.2.h),
                            radius: 1.5.r,
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 0.w),
                          child: Column(
                            children: [
                              SizedBox(height: 35.h),
                              Stack(
                                children: [
                                  ListTile(
                                    leading: ClipOval(
                                        child: Image.network(
                                      widget.image,
                                      height: 25.h,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                          'assets/images/noavatar.png',
                                          height: 25.h,
                                        ); // Fallback image
                                      },
                                    )),
                                    title: Text(
                                      "Hi ${widget.name}",
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.primaryClr,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 5.w,
                                    child: GestureDetector(
                                      onTap: () => Menu.showMenu(context),
                                      child: SizedBox(
                                        height: 50.h,
                                        width: 60.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(15.w),
                                          child: SvgPicture.asset(
                                            'assets/svg/hamburger.svg',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 60.h),
                                Text(
                                  'Today\'s Wash',
                                  style: GoogleFonts.inter(
                                    color: AppTemplate.textClr,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        dashboardController.washInfoList.length,
                                    itemBuilder: (context, index) {
                                      final washInfo = dashboardController
                                          .washInfoList[index];
                                      return Visibility(
                                        visible: washInfo != null,
                                        replacement: Text('No Record Found'),
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                              padding: EdgeInsets.all(15.h),
                                              decoration: BoxDecoration(
                                                color: AppTemplate.primaryClr,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFE1E1E1)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFFE1E1E1),
                                                    blurRadius: 4.r,
                                                    spreadRadius: 0.r,
                                                    offset: Offset(0.w, 4.h),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        washInfo[
                                                                'vehicle_no'] ??
                                                            'Unknown Vehicle',
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: AppTemplate
                                                              .textClr,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        washInfo['wash_status'] ==
                                                                "Completed"
                                                            ? 'Completed'
                                                            : 'Pending',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              washInfo["wash_status"] ==
                                                                      "Completed"
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      86,
                                                                      156,
                                                                      0,
                                                                      10)
                                                                  : const Color
                                                                      .fromRGBO(
                                                                      255,
                                                                      195,
                                                                      0,
                                                                      10),
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          color: const Color(
                                                              0xFF001C63),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.w,
                                                                  vertical:
                                                                      3.h),
                                                          child: Text(
                                                            washInfo[
                                                                    'wash_type'] ??
                                                                'Unknown Wash Type',
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 8.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppTemplate
                                                                  .primaryClr,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8.h),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 20,
                                              bottom: 30,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    washInfo['employee_name'] ??
                                                        'Unknown Employee',
                                                    style: GoogleFonts.inter(
                                                      color:
                                                          AppTemplate.textClr,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 8.sp,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  CircleAvatar(
                                                    radius: 12.5.r,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      washInfo['employee_pic'] !=
                                                              null
                                                          ? washInfo[
                                                              'employee_pic']
                                                          : 'assets/images/noavatar.png',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 100.h,
                    left: 25.w,
                    right: 25.w,
                    bottom: 480.h,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFD4D4D4), width: 1.5.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4D4D4),
                            blurRadius: 2.r,
                            offset: Offset(0.w, 3.h),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppTemplate.primaryClr,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Strength",
                              style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Obx(() {
                                      return Text(
                                        dashboardController.employeeCount.value,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.buttonClr,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                                    Text(
                                      "Employee",
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                // Customer Count
                                Column(
                                  children: [
                                    Obx(() {
                                      return Text(
                                        dashboardController.customerCount.value,
                                        style: GoogleFonts.inter(
                                          color: AppTemplate.buttonClr,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                                    Text(
                                      "Customers",
                                      style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
