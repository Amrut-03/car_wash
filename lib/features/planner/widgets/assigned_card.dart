import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/wash_type.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AssignedCard extends ConsumerStatefulWidget {
  const AssignedCard({
    super.key,
    required this.washTypes,
    required this.assignedCar,
    required this.cleanerKey,
    required this.onAssigned,
  });
  final List<WashType> washTypes;
  final AssignedCar assignedCar;
  final String cleanerKey;
  final VoidCallback onAssigned;

  @override
  ConsumerState<AssignedCard> createState() => _AssignedCardState();
}

class _AssignedCardState extends ConsumerState<AssignedCard> {
  String? currentOption;
  final TextEditingController remarks = TextEditingController();
  @override
  void initState() {
    super.initState();
    currentOption = widget.assignedCar.washId;
    remarks.text = widget.assignedCar.remarks;
  }

  Future<void> unAssign() async {
    final admin = ref.watch(authProvider);
    var url =
        Uri.parse('https://wash.sortbe.com/API/Admin/Planner/Car-UnAssign');
    var request = http.MultipartRequest('POST', url)
      ..fields['enc_key'] = encKey
      ..fields['emp_id'] = admin.admin!.id
      ..fields['planner_date'] = plannerDate
      ..fields['car_id'] = widget.assignedCar.carId
      ..fields['cleaner_key'] = widget.cleanerKey;

    try {
      if (!mounted) return;
      // throw 'Error';
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 'Success') {
        if (mounted) {
          Navigator.pop(context);
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
          Navigator.pop(context);
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Error: $e',
              style: GoogleFonts.inter(
                color: AppTemplate.primaryClr,
                fontWeight: FontWeight.w400,
              ),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> update() async {
    final admin = ref.watch(authProvider);
    print('admin = ${admin.admin!.id}');
    var url = Uri.parse('https://wash.sortbe.com/API/Admin/Planner/Car-Update');
    var request = http.MultipartRequest('POST', url)
      ..fields['enc_key'] = encKey
      ..fields['emp_id'] = admin.admin!.id
      ..fields['planner_date'] = plannerDate
      ..fields['car_id'] = widget.assignedCar.carId
      ..fields['cleaner_key'] = widget.cleanerKey
      ..fields['service_id'] = currentOption!
      ..fields['remarks'] = remarks.text;
    try {
      if (!mounted) return;
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 'Success') {
        if (mounted) {
          Navigator.pop(context);
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
          Navigator.pop(context);
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Error: $e',
              style: GoogleFonts.inter(
                color: AppTemplate.primaryClr,
                fontWeight: FontWeight.w400,
              ),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final plannerNotifier = ref.read(plannerProvider.notifier);
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
                                        widget.washTypes[index].washName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      value: widget.washTypes[index].washId,
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
                                    controller: remarks,
                                    textAlignVertical: TextAlignVertical.top,
                                    cursorColor: AppTemplate.enabledBorderClr,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'Remarks',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: const Color(0xFF929292),
                                          fontWeight: FontWeight.w400),
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
                                        flex: 6,
                                        child: Buttonwidget(
                                          width: 0.w,
                                          height: 50.h,
                                          buttonClr: const Color(0xFFC80000),
                                          txt: 'Un-Assign',
                                          textClr: AppTemplate.primaryClr,
                                          textSz: 17,
                                          onClick: () async {
                                            await unAssign();
                                            plannerNotifier
                                                .plannerEmployeeList();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        flex: 4,
                                        child: Buttonwidget(
                                          width: 0.w,
                                          height: 50.h,
                                          buttonClr: const Color(0xFF1E3763),
                                          txt: 'Update',
                                          textClr: AppTemplate.primaryClr,
                                          textSz: 17,
                                          onClick: () async {
                                            await update();
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
          },
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.end,
              //mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: 15.h),
                Text(
                  widget.assignedCar.vehicleNo,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  widget.assignedCar.clientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  widget.assignedCar.washName,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(height: 20.h),
      ],
    );
  }
}
