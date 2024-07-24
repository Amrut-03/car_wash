
import 'package:car_wash/common/widgets/createCustomerCard.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/recentWashesList.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  Future<void> gotoMap() async {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$long";
      final Uri url0 = Uri.parse(url);
      if (!await launchUrl(url0)) {
        throw 'Could not launch $url0';
      }
    } catch (e) {
      print("Error launching map: $e");
    }
  }

  Future<void> openMap() async {
    if (lat!.isFinite && long!.isFinite) {
      Position(
        latitude: lat!,
        longitude: long!,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        altitudeAccuracy: 1.0,
        heading: 1.0,
        headingAccuracy: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
      );
      gotoMap();
    }
  }

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

  String selectedMonth = 'July';

  int selectedYear = 2024;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(txt: 'Abinanthan'),
          Padding(
            padding: EdgeInsets.all(25.w),
            child: Container(
              decoration: BoxDecoration(
                  color: AppTemplate.primaryClr,
                  borderRadius: BorderRadius.circular(10.r),
                  border:
                      Border.all(color: const Color(0xFFE1E1E1), width: 1.5.w),
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
                    child: Image.asset(
                      'assets/images/car1.png',
                      height: 100.h,
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
                          'TN 45 AK 1234',
                          style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: AppTemplate.textClr,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Hyundai Verna',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF001C63),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                openMap();
                              },
                              child: Text(
                                'View Location',
                                style: GoogleFonts.inter(
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 1.5.w,
                                    fontSize: 11.sp,
                                    color: AppTemplate.textClr,
                                    fontWeight: FontWeight.w800),
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
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
            child: Text(
              'Previous Washes',
              style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppTemplate.textClr,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  height: 34.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: const Color(0xFFD4D4D4))),
                  child: Center(
                    child: DropdownButton<String>(
                      dropdownColor: AppTemplate.primaryClr,
                      value: selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                        });
                      },
                      items:
                          months.map<DropdownMenuItem<String>>((String value) {
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
                      dropdownColor: AppTemplate.primaryClr,
                      value: selectedYear,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items: years.map<DropdownMenuItem<int>>((int value) {
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
          const RecentWashesList(),
        ],
      ),
    );
  }
}
