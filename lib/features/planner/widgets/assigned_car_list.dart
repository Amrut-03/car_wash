import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/wash_type.dart';
import 'package:car_wash/features/planner/widgets/assigned_card.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class AssignedCarList extends ConsumerStatefulWidget {
  const AssignedCarList(
      {super.key,
      required this.assignedCars,
      required this.washTypes,
      required this.start,
      required this.end,
      required this.cleanerKey,
      required this.onAssigned});
  final List<AssignedCar> assignedCars;
  final List<WashType> washTypes;
  final String start;
  final String end;
  final String cleanerKey;
  final VoidCallback onAssigned;

  @override
  ConsumerState<AssignedCarList> createState() => _AssignedCarListState();
}

class _AssignedCarListState extends ConsumerState<AssignedCarList> {
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController startKm = TextEditingController();
  final TextEditingController endKm = TextEditingController();
  List<AssignedCar> _assignedCars = [];
  bool isLoading = false;

  bool _isExpanded = false;
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    startKm.text = '';
    endKm.text = '';
    _assignedCars = [];
  }

  @override
  void didUpdateWidget(covariant AssignedCarList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assignedCars != widget.assignedCars) {
      setState(() {
        startKm.text = widget.start;
        endKm.text = widget.end;
        _assignedCars = widget.assignedCars.toList();
      });
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _assignedCars.removeAt(oldIndex);
      _assignedCars.insert(newIndex, item);
    });
  }

  Future<void> sortlist() async {
    setState(() {
      isLoading = true;
    });
    const url = 'https://wash.sortbe.com/API/Admin/Planner/Planner-Sorting';
    final admin = ref.read(adminProvider);
    List<String> carIds = _assignedCars.map((car) => car.carId).toList();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': admin.id,
          'planner_date': plannerDate,
          'cleaner_key': widget.cleanerKey,
          'car_order': jsonEncode(carIds),
          'start_km': startKm.text,
          'end_km': endKm.text,
        },
      );
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
      print('Errore = $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    startKm.dispose();
    endKm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
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
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Assigned Cars",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF447B00),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 20.h,
                  width: 20.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF021649),
                  ),
                  child: Center(
                    child: Text(
                      '${_assignedCars.length}',
                      style: const TextStyle(
                        color: AppTemplate.primaryClr,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleExpansion,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                AnimatedSize(
                  duration: _animationDuration,
                  curve: Curves.easeInOut,
                  child: Visibility(
                    visible: _isExpanded,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Textfieldwidget(
                                      controller: startKm,
                                      labelTxt: 'Start Km',
                                      labelTxtClr: const Color(0xFF929292),
                                      enabledBorderClr: const Color(0xFFD4D4D4),
                                      focusedBorderClr: const Color(0xFFD4D4D4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Textfieldwidget(
                                      controller: endKm,
                                      labelTxt: 'End Km',
                                      labelTxtClr: const Color(0xFF929292),
                                      enabledBorderClr: const Color(0xFFD4D4D4),
                                      focusedBorderClr: const Color(0xFFD4D4D4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            onReorder: _onReorder,
                            itemCount: _assignedCars.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: AppTemplate.primaryClr,
                                key: ValueKey(_assignedCars[index]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            13, 48, 48, 48),
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
                                    child: AssignedCard(
                                      washTypes: widget.washTypes,
                                      assignedCar: _assignedCars[index],
                                      cleanerKey: widget.cleanerKey,
                                      onAssigned: widget.onAssigned,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Buttonwidget(
                              width: 145.w,
                              height: 50.h,
                              buttonClr: const Color(0xFF1E3763),
                              txt: 'Update',
                              textClr: AppTemplate.primaryClr,
                              textSz: 18.sp,
                              onClick: () {
                                sortlist();
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: SizedBox(
                    width: ScreenUtil().screenWidth,
                    height: 300,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
