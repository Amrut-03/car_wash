import 'dart:convert';
import 'dart:developer';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/model/customer_profile_model.dart';
import 'package:car_wash/features/customer/widgets/customer_recent_washes.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:http/http.dart' as http;

class CarDetails extends ConsumerStatefulWidget {
  const CarDetails({super.key, required this.carItem, required this.name});
  final CarItem carItem;
  final String name;

  @override
  ConsumerState<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends ConsumerState<CarDetails> {
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<int> years = List.generate(100, (index) => 2000 + index);
  late String selectedMonth;
  late int selectedYear;
  List<WashListItem>? washListItem;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    selectedMonth = months[now.month - 1];
    selectedYear = now.year;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCarWashList();
  }

  Future<void> openMap(String lat, String long) async {
    final double latitude = double.parse(lat);
    final double longitude = double.parse(long);
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  Future<void> fetchCarWashList() async {
    const url = 'https://wash.sortbe.com/API/Admin/Client/Car-Wash-List';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'car_id': widget.carItem.carId,
          'month': (months.indexOf(selectedMonth) + 1).toString(),
          'year': selectedYear.toString(),
        },
      );

      print('year = ${selectedYear.toString()}');
      print('month = ${(months.indexOf(selectedMonth) + 1).toString()}');

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        print('data $responseData');

        setState(() {
          washListItem = WashListItem.fromJsonList(responseData['wash_list']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: washListItem == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(txt: widget.name),
                Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            color: const Color(0xFFE1E1E1), width: 1.5.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE1E1E1),
                            offset: Offset(0.w, 4.h),
                            blurRadius: 4.r,
                          )
                        ]),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.network(
                            widget.carItem.carImage,
                            height: 100.h,
                            width: 120.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100.h,
                                width: 120.h,
                                child: Center(
                                  child: Text(
                                    'Failed to load',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.carItem.vehicleNo,
                                style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppTemplate.textClr,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.carItem.modelName,
                                style: GoogleFonts.inter(
                                    fontSize: 11.0,
                                    color: const Color(0xFF001C63),
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await openMap(
                                        widget.carItem.latitude,
                                        widget.carItem.longitude,
                                      );
                                    },
                                    child: Text(
                                      'View Location',
                                      style: GoogleFonts.inter(
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationThickness: 1.5.w,
                                        fontSize: 11.0,
                                        color: AppTemplate.textClr,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25.w,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/carwash.svg',
                                    height: 18.h,
                                    width: 15.w,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                  child: Text(
                    'Previous Washes',
                    style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: AppTemplate.textClr,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Container(
                        height: 34.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: const Color(0xFFD4D4D4),
                          ),
                        ),
                        child: Center(
                          child: DropdownButton<String>(
                            underline: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTemplate.primaryClr,
                                ),
                              ),
                            ),
                            dropdownColor: AppTemplate.primaryClr,
                            value: selectedMonth,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedMonth = newValue!;
                                fetchCarWashList();
                              });
                            },
                            items: months
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        height: 34.h,
                        width: 89.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFD4D4D4))),
                        child: Center(
                          child: DropdownButton<int>(
                            underline: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTemplate.primaryClr,
                                ),
                              ),
                            ),
                            dropdownColor: AppTemplate.primaryClr,
                            value: selectedYear,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedYear = newValue!;
                                fetchCarWashList();
                              });
                            },
                            items:
                                years.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomerRecentWashesList(
                  washList: washListItem!,
                  customerName: widget.name,
                )
              ],
            ),
    );
  }
}
