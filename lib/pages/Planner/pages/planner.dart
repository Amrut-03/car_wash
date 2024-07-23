import 'dart:convert';
import 'dart:io';

import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Planner/model/cars.dart';
import 'package:car_wash/pages/Planner/model/wash_type.dart';
import 'package:car_wash/pages/Planner/widgets/assigned_card.dart';
import 'package:car_wash/pages/Planner/widgets/cars_to_wash_widget.dart';
import 'package:car_wash/provider/car_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Planner extends ConsumerStatefulWidget {
  const Planner({super.key, required this.empName, required this.empId});
  final String empName;
  final String empId;

  @override
  ConsumerState<Planner> createState() => _PlannerState();
}

class _PlannerState extends ConsumerState<Planner> {
  bool _isExpanded = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  TextEditingController searchEmployee = TextEditingController();
  List<WashType> washTypes = [];
  List<dynamic> assignedCars = [];
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWashes();
  }

  Future<void> fetchWashes() async {
    var url = Uri.parse('https://wash.sortbe.com/API/Wash-Names');

    try {
      var response = await http.post(
        url,
        body: {'enc_key': 'C0oRAe1QNtn3zYNvJ8rv'},
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == "Success") {
        print(responseData['data']);
        setState(() {
          washTypes = (responseData['data'] as List)
              .map((item) => WashType.fromJson(item))
              .toList();
        });
      } else {
        // Handle server error
        print('Server error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // Handle network error
      print('Network error: $e');
    } on http.ClientException catch (e) {
      // Handle client error
      print('Client error: $e');
    } catch (e) {
      // Handle other errors
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(adminProvider);
    final carParams = CarParams(
      empId: admin!.id,
      searchName: searchEmployee.text,
      cleanerKey: widget.empId,
    );
    return ref.watch(carProvider(carParams)).when(
          data: (carLists) {
            List<AllCar> allCars = carLists.allCars;
            List<AssignedCar> assignedCars = carLists.assignedCars;
            return Scaffold(
              backgroundColor: AppTemplate.primaryClr,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Header(txt: 'Planner'),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Text(
                          'Schedule Planner',
                          style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Textfieldwidget(
                        controller: searchEmployee,
                        labelTxt: 'Search by Car Number or Client',
                        labelTxtClr: const Color(0xFF929292),
                        enabledBorderClr: const Color(0xFFD4D4D4),
                        focusedBorderClr: const Color(0xFFD4D4D4),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Text(
                          '${widget.empName} - $formattedDate',
                          style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 15.w, right: 10.w, top: 5.w),
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
                                  child: const Center(
                                    child: Text(
                                      '4',
                                      style: TextStyle(
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
                            const SizedBox(
                              height: 10,
                            ),
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
                                                padding:
                                                    EdgeInsets.only(left: 5.w),
                                                child: Textfieldwidget(
                                                  controller: searchEmployee,
                                                  labelTxt: 'Start Km',
                                                  labelTxtClr:
                                                      const Color(0xFF929292),
                                                  enabledBorderClr:
                                                      const Color(0xFFD4D4D4),
                                                  focusedBorderClr:
                                                      const Color(0xFFD4D4D4),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: SizedBox(
                                              height: 50,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: Textfieldwidget(
                                                  controller: searchEmployee,
                                                  labelTxt: 'End Km',
                                                  labelTxtClr:
                                                      const Color(0xFF929292),
                                                  enabledBorderClr:
                                                      const Color(0xFFD4D4D4),
                                                  focusedBorderClr:
                                                      const Color(0xFFD4D4D4),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      ListView.builder(
                                        itemBuilder: (context, index) {
                                          return AssignedCard(
                                              washTypes: washTypes,
                                              assignedCars: assignedCars);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25.w, vertical: 0),
                        child: Text(
                          'Cars to Wash',
                          style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 400),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allCars.length,
                        itemBuilder: (context, index) {
                          return CarsToWashWidget(
                            washTypes: washTypes,
                            car: allCars[index],
                            currentDate: formattedDate,
                            empId: widget.empId,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Text('Error = $error'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
