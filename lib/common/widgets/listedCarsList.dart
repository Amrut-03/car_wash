import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/model/customer_profile_model.dart';
import 'package:car_wash/features/customer/pages/cardetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Listedcarslist extends StatefulWidget {
  const Listedcarslist({super.key, required this.carItem, required this.name});
  final List<CarItem> carItem;
  final String name;

  @override
  State<Listedcarslist> createState() => _ListedcarslistState();
}

class _ListedcarslistState extends State<Listedcarslist> {
  Future<void> openMap(String lat, String long) async {
    final double latitude = double.parse(lat);
    final double longitude = double.parse(long);
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return widget.carItem.isEmpty
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'No cars available',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: widget.carItem.length,
              itemBuilder: (context, index) {
                final car = widget.carItem[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetails(
                              carItem: widget.carItem[index],
                              name: widget.name,
                            ),
                          ),
                        ),
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
                              Container(
                                height: 100.h,
                                width: 120.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: Image.network(
                                    car.carImage,
                                    height: 100.h,
                                    width: 120.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/car.jpg',
                                        fit: BoxFit.cover,
                                        height: 100.h,
                                        width: 120.h,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
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
                                      car.vehicleNo,
                                      style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppTemplate.textClr,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      car.modelName,
                                      style: GoogleFonts.inter(
                                          fontSize: 11.0,
                                          color: const Color(0xFF001C63),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            openMap(
                                              car.latitude,
                                              car.longitude,
                                            );
                                          },
                                          child: Text(
                                            'View Location',
                                            style: GoogleFonts.inter(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                decorationThickness: 1.5.w,
                                                fontSize: 11.0,
                                                color: AppTemplate.textClr,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
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
