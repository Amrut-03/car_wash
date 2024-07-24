import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/wash_type.dart';
import 'package:car_wash/features/planner/widgets/assigned_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignedCarList extends StatefulWidget {
  const AssignedCarList({
    super.key,
    required this.assignedCars,
    required this.washTypes,
    required this.start,
    required this.end, required this.cleanerKey,
    required this.onAssigned
  });
  final List<AssignedCar> assignedCars;
  final List<WashType> washTypes;
  final String start;
  final String end;
  final String cleanerKey;
  final VoidCallback onAssigned;

  @override
  State<AssignedCarList> createState() => _AssignedCarListState();
}

class _AssignedCarListState extends State<AssignedCarList> {
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController startKm = TextEditingController();
  final TextEditingController endKm = TextEditingController();

  bool _isExpanded = false;
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
  

  @override
  void initState() {
    super.initState();
    // Set initial value
    startKm.text = widget.start;
    endKm.text = widget.end;
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
                      '${widget.assignedCars.length}',
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.assignedCars.length,
                        itemBuilder: (context, index) {
                          return AssignedCard(
                            washTypes: widget.washTypes,
                            assignedCar: widget.assignedCars[index],
                            cleanerKey: widget.cleanerKey,
                            onAssigned: widget.onAssigned,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
