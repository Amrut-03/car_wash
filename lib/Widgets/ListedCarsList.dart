import 'package:car_wash/Widgets/CreateCustomerCard.dart';
import 'package:car_wash/pages/Customer/cardetails.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Listedcarslist extends StatefulWidget {
  const Listedcarslist({super.key});

  @override
  State<Listedcarslist> createState() => _ListedcarslistState();
}

class _ListedcarslistState extends State<Listedcarslist> {
  Future<void> gotoMap() async {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=${lat},${long}";
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CarDetails())),
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
                          child: Image.asset(
                            index == 0
                                ? 'assets/images/car1.png'
                                : 'assets/images/car2.png',
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
                                          decorationStyle:
                                              TextDecorationStyle.solid,
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
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
