import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/listedCarsList.dart';
import 'package:car_wash/common/widgets/recentWashesList.dart';
import 'package:car_wash/features/customer/customer.dart';
import 'package:car_wash/features/customer/editCustomer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CustomerProfile extends StatefulWidget {
  final String customerName;
  final String customerId;
  const CustomerProfile({
    super.key,
    required this.customerName,
    required this.customerId,
  });

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  bool isCarWashed = true;

  void showCustomerOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppTemplate.primaryClr,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10.h,
                  width: 150.w,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/edit.svg'),
                  title: Text('Edit Employee',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditCustomer()));
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/svg/removePerson.svg'),
                  title: Text('Remove Employee',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 18.sp)),
                  onTap: () async {
                    await removeCustomer();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Customer()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> removeCustomer() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Remove'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': '123',
      'customer_id': widget.customerId,
      'password': '12345665'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTemplate.bgClr,
          content: Text(
            'Customer Removed Successfully',
            style: GoogleFonts.inter(
                color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
          )));
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          children: [
            const Header(txt: 'Customer Profile'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: GestureDetector(
                onTap: () {
                  showCustomerOptions(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTemplate.primaryClr,
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFFE1E1E1),
                            blurRadius: 4.r,
                            spreadRadius: 0.r,
                            offset: Offset(0.w, 4.h))
                      ],
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFE1E1E1))),
                  child: Padding(
                    padding: EdgeInsets.all(15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customerName,
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "87686798989",
                              style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF001C63)),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/car.svg'),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  '2',
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF6750A4),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.r,
                        ),
                        Text(
                          'Since May 2024',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: AppTemplate.textClr,
                              fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCarWashed = !isCarWashed;
                    });
                  },
                  child: Container(
                      width: 135.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isCarWashed
                                  ? Colors.transparent
                                  : const Color(0xFF001C63),
                              width: 2.w),
                          borderRadius: BorderRadius.circular(5.r),
                          color: isCarWashed
                              ? const Color(0xFF001C63)
                              : AppTemplate.primaryClr),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        child: Center(
                          child: Text('Recent Washes',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: isCarWashed
                                    ? AppTemplate.primaryClr
                                    : const Color(0xFF001C63),
                              )),
                        ),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCarWashed = !isCarWashed;
                    });
                  },
                  child: Container(
                      width: 130.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: !isCarWashed
                                  ? Colors.transparent
                                  : const Color(0xFF001C63),
                              width: 2.w),
                          color: !isCarWashed
                              ? const Color(0xFF001C63)
                              : AppTemplate.primaryClr),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        child: Center(
                          child: Text(
                            'Listed Cars',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: !isCarWashed
                                  ? AppTemplate.primaryClr
                                  : const Color(0xFF001C63),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            isCarWashed ? const RecentWashesList() : const Listedcarslist()
          ],
        ),
      ),
    );
  }
}
