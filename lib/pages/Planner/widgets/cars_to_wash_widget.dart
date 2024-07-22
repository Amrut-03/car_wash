import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CarsToWashWidget extends StatefulWidget {
  const CarsToWashWidget({super.key, required this.washTypes});
  final List<dynamic> washTypes;

  @override
  State<CarsToWashWidget> createState() => _CarsToWashWidgetState();
}

List<String> options = [
  'Exterior',
  'Interior',
  'Interior & Pressure Wash',
  'Pressure Wash'
];

class _CarsToWashWidgetState extends State<CarsToWashWidget> {
  String? currentOption;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    final keyboardHeight =
                        MediaQuery.of(context).viewInsets.bottom;
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: keyboardHeight + 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 10,
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9B9B9B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.washTypes.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      fillColor: const WidgetStatePropertyAll(
                                        Colors.black,
                                      ),
                                      title: Text(
                                        widget.washTypes[index]['wash_types'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      value: widget.washTypes[index]
                                          ['wash_types'],
                                      groupValue: currentOption,
                                      onChanged: (value) {
                                        setState(() {
                                          currentOption = value.toString();
                                        });
                                        // Also update the state of the parent widget
                                        this.setState(() {
                                          currentOption = value.toString();
                                        });
                                      },
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: TextField(
                                    maxLines: 5,
                                    textAlignVertical: TextAlignVertical.top,
                                    cursorColor: AppTemplate.enabledBorderClr,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      // label: const Text(
                                      //   'Remarks',
                                      // ),
                                      hintText: 'Remarks',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          color: const Color(0xFF929292),
                                          fontWeight: FontWeight.w400),
                                      // labelStyle: GoogleFonts.inter(
                                      //     fontSize: 15.sp,
                                      //     color: const Color(0xFF929292),
                                      //     fontWeight: FontWeight.w400),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        borderSide: BorderSide(
                                            color: AppTemplate.shadowClr,
                                            width: 1.5.w),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        borderSide: BorderSide(
                                            color: AppTemplate.shadowClr,
                                            width: 1.5.w),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Buttonwidget(
                                          width: 0.w,
                                          height: 50.h,
                                          buttonClr: const Color(0xFF929292),
                                          txt: 'Cancel',
                                          textClr: AppTemplate.primaryClr,
                                          textSz: 18.sp,
                                          onClick: () {},
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        flex: 6,
                                        child: Buttonwidget(
                                          width: 0.w,
                                          height: 50.h,
                                          buttonClr: const Color(0xFF1E3763),
                                          txt: 'Assign',
                                          textClr: AppTemplate.primaryClr,
                                          textSz: 18.sp,
                                          onClick: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Container(
              height: 80,
              padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(13, 48, 48, 48),
                ),
                color: AppTemplate.primaryClr,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align texts to the start
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('TN 45 AK 1234'),
                      Text('Suresh'),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF447B00),
                    ),
                    child: const Icon(
                      Icons.done,
                      color: AppTemplate.primaryClr,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
