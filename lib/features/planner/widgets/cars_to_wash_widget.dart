import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/features/planner/model/all_car.dart';
import 'package:car_wash/features/planner/model/wash_type.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CarsToWashWidget extends ConsumerStatefulWidget {
  const CarsToWashWidget({
    super.key,
    required this.washTypes,
    required this.car,
    required this.cleanerKey,
    required this.onAssigned,
  });
  final List<WashType> washTypes;
  final AllCar car;
  final String cleanerKey;
  final VoidCallback onAssigned;

  @override
  ConsumerState<CarsToWashWidget> createState() => _CarsToWashWidgetState();
}

class _CarsToWashWidgetState extends ConsumerState<CarsToWashWidget> {
  final TextEditingController remarksController = TextEditingController();
  WashType? currentOption;

  Future<void> assign(WashType washType) async {
    final admin = ref.read(adminProvider);
    var url =
        Uri.parse('https://wash.sortbe.com/API/Admin/Planner/Planner-Option');
    var request = http.MultipartRequest('POST', url)
      ..fields['enc_key'] = encKey
      ..fields['remarks'] = remarksController.text
      ..fields['emp_id'] = admin!.id
      ..fields['planner_date'] = plannerDate
      ..fields['client_id'] = widget.car.clientId
      ..fields['service_id'] = washType.washId
      ..fields['cleaner_key'] = widget.cleanerKey;
    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'Success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['remarks']),
              backgroundColor: Colors.green,
            ),
          );
          widget.onAssigned();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['remarks']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        print('Exce = $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppTemplate.bgClr,
              content: Text(
                'Exception: $e',
                style: GoogleFonts.inter(
                    color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
              )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.car.alloted == null) {
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.washTypes.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile<WashType>(
                                        fillColor: const WidgetStatePropertyAll(
                                          Colors.black,
                                        ),
                                        title: Text(
                                          widget.washTypes[index].washName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        value: widget.washTypes[index],
                                        groupValue: currentOption,
                                        onChanged: (value) {
                                          print('----=-=-=');
                                          print(value);
                                          setState(() {
                                            currentOption = value;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: TextField(
                                      controller: remarksController,
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
                                            onClick: () async {
                                              if (currentOption != null) {
                                                await assign(currentOption!);
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        AppTemplate.bgClr,
                                                    content: Text(
                                                      'Please select a wash type',
                                                      style: GoogleFonts.inter(
                                                          color: AppTemplate
                                                              .primaryClr,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
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
            }
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
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align texts to the start
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.car.vehicleNo),
                      Text(widget.car.clientName),
                    ],
                  ),
                  widget.car.alloted != null
                      ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF447B00),
                          ),
                          child: const Icon(
                            Icons.done,
                            color: AppTemplate.primaryClr,
                          ),
                        )
                      : const SizedBox(),
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
