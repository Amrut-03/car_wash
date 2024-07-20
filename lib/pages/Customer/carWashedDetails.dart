import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/CreateCustomerCard.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

TextEditingController issueController = TextEditingController();

class CarWashedDetails extends StatefulWidget {
  const CarWashedDetails({super.key});

  @override
  State<CarWashedDetails> createState() => _CarWashedDetailsState();
}

class _CarWashedDetailsState extends State<CarWashedDetails> {
  String isTicket = 'Close Ticket';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTicket;
  }

  @override
  Widget build(BuildContext context) {
    void _showModalBottomSheet(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: AppTemplate.primaryClr,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                  SizedBox(height: 15.h),
                  TextField(
                    cursorColor: const Color(0xFFD4D4D4),
                    controller: issueController,
                    decoration: InputDecoration(
                      labelText: 'Issue Remarks',
                      labelStyle:
                          GoogleFonts.inter(color: const Color(0xFF929292)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFFD4D4D4), width: 1.5.w)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFFD4D4D4), width: 1.5.w)),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(227.w, 50.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r)),
                      backgroundColor: const Color(0xFF1E3763),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 15.h,
                      ),
                    ),
                    child: Text(
                      'Create Ticket',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Abinanthan'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Abinanthan',
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp),
                          ),
                          Text(
                            "13 July 2024",
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp),
                          ),
                        ],
                      ),
                      Text(
                        '+91 98765 43210',
                        style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF001C63)),
                      ),
                      SizedBox(
                        height: 15.r,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exterior Wash',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: AppTemplate.textClr,
                                fontSize: 12.sp),
                          ),
                          Text(
                            'Pending',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(255, 195, 0, 10),
                                fontSize: 13.sp),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Before Wash',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppTemplate.textClr,
                    fontSize: 13.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Container(
                height: 140.h,
                width: 220.w,
                decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFE1E1E1),
                          blurRadius: 4.r,
                          spreadRadius: 0.r,
                          offset: Offset(0.w, 4.h))
                    ],
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xFFE1E1E1))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.asset(
                    'assets/images/bmw.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'After Wash',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppTemplate.textClr,
                    fontSize: 13.sp),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 140.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  blurRadius: 4.r,
                                  spreadRadius: 0.r,
                                  offset: Offset(0.w, 4.h))
                            ],
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: const Color(0xFFE1E1E1))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            'assets/images/bmw.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTemplate.primaryClr,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE1E1E1),
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h))
                          ],
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: const Color(0xFFE1E1E1))),
                      child: SizedBox(
                          height: 140.h,
                          width: 220.w,
                          child: const Image(
                            image: AssetImage('assets/images/bmw1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    )
                  ],
                ),
              ),
            ),
            issueController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(25.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ticket',
                              style: GoogleFonts.inter(
                                  color: AppTemplate.textClr,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTemplate.textClr),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Are You Sure?',
                                        style: GoogleFonts.inter(
                                            color: AppTemplate.textClr,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFf1E3763)),
                                                  child: Text(
                                                    'Yes',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      isTicket =
                                                          'Ticket Closed';
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFf1E3763)),
                                                  child: Text(
                                                    'No',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ]),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                isTicket,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFC80000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFFC80000),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          issueController.text,
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showModalBottomSheet(context),
                    child: Container(
                        width: 69.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: const Color(0xFFC80000),
                            width: 1.5.w,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.w),
                          child: SvgPicture.asset(
                            'assets/svg/puzzle.svg',
                          ),
                        )),
                  ),
                  Buttonwidget(
                    width: 227.w,
                    height: 50.h,
                    buttonClr: const Color(0xFf1E3763),
                    txt: 'Send to Whatsapp',
                    textClr: AppTemplate.primaryClr,
                    textSz: 16.sp,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
