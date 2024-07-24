import 'dart:convert';
import 'dart:io';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/planner/model/all_car.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/car_lists.dart';
import 'package:car_wash/features/planner/model/car_params.dart';
import 'package:car_wash/features/planner/model/wash_type.dart';
import 'package:car_wash/features/planner/widgets/assigned_car_list.dart';
import 'package:car_wash/features/planner/widgets/cars_to_wash_widget.dart';
import 'package:car_wash/provider/car_provider.dart';
import 'package:car_wash/provider/provider.dart';
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
  TextEditingController searchEmployee = TextEditingController();
  List<WashType> washTypes = [];
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchWashes();
  }

  void refreshPage() {
    setState(() {});
  }

  Future<void> fetchWashes() async {
    var url = Uri.parse('https://wash.sortbe.com/API/Wash-Names');

    try {
      var response = await http.post(
        url,
        body: {'enc_key': encKey},
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == "Success") {
        print('Wash Types Data: ${responseData['data']}');
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

    if (admin == null) {
      return Scaffold(
        backgroundColor: AppTemplate.primaryClr,
        body: Center(
          child: Text(
            'No admin data available',
            style: GoogleFonts.inter(
              color: AppTemplate.textClr,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final carParams = CarParams(
      empId: admin.id,
      searchName: searchEmployee.text,
      cleanerKey: widget.empId,
    );
    final asyncValue = ref.watch(carProvider(carParams).future);

    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: FutureBuilder<CarLists>(
        future: asyncValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final carLists = snapshot.data!;
            List<AllCar> allCars = carLists.allCars;
            List<AssignedCar> assignedCars = carLists.assignedCars;
            String startKm = carLists.startKm;
            String endKm = carLists.endKm;

            return SingleChildScrollView(
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
                  SizedBox(height: 20.h),
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
                  SizedBox(height: 20.h),
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
                  SizedBox(height: 20.h),
                  AssignedCarList(
                    assignedCars: assignedCars,
                    washTypes: washTypes,
                    start: startKm,
                    end: endKm,
                    cleanerKey: widget.empId,
                    onAssigned: refreshPage,
                    
                  ),
                  SizedBox(height: 30.h),
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
                          cleanerKey: widget.empId,
                          onAssigned: refreshPage,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
