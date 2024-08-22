import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/planner/model/all_car.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/car_params.dart';
import 'package:car_wash/features/planner/widgets/assigned_car_list.dart';
import 'package:car_wash/features/planner/widgets/cars_to_wash_widget.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Planner extends ConsumerStatefulWidget {
  const Planner({super.key, required this.empName, required this.empId});
  final String empName;
  final String empId;

  @override
  ConsumerState<Planner> createState() => _PlannerState();
}

class _PlannerState extends ConsumerState<Planner> {
  TextEditingController searchEmployee = TextEditingController();

  List<AllCar> allCars = [];
  List<AssignedCar> assignedCars = [];
  List<AllCar> filteredCars = [];
  String start = '';
  String end = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ref.read(empIdProvider.notifier);
    searchEmployee.addListener(_filterCars);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCars();
  }

  @override
  void dispose() {
    searchEmployee.removeListener(_filterCars);
    searchEmployee.dispose();
    super.dispose();
  }

  void _filterCars() {
    final query = searchEmployee.text.toLowerCase();
    setState(() {
      filteredCars = allCars.where((car) {
        final carNumber = car.vehicleNo.toLowerCase();
        final clientName = car.clientName.toLowerCase();
        return carNumber.contains(query) || clientName.contains(query);
      }).toList();
    });
  }

  void refreshPage() {
    fetchCars();
  }

  Future<void> fetchCars() async {
    const url = 'https://wash.sortbe.com/API/Admin/Planner/Client-Planner';

    final admin = ref.watch(authProvider);

    if (admin.admin == null) {
      print('Error: Admin is null');
    }

    final carParams = await CarParams(
      empId: admin.admin!.id,
      searchName: searchEmployee.text,
      cleanerKey: widget.empId,
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': carParams.empId,
          'search_name': carParams.searchName,
          'planner_date': plannerDate,
          'cleaner_key': carParams.cleanerKey,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> allCarsJson = responseData['data']['all_cars'] ?? [];
        List<dynamic> assignedCarsJson =
            responseData['data']['assigned_cars'] ?? [];
        if (mounted) {
          setState(() {
            allCars =
                List<AllCar>.from(allCarsJson.map((x) => AllCar.fromJson(x)));
            assignedCars = List<AssignedCar>.from(
                assignedCarsJson.map((x) => AssignedCar.fromJson(x)));
            start = responseData['start_km'];
            end = responseData['end_km'];
            filteredCars = allCars;
          });
        }
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      print('Error = $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Future<void> fetchWashes() async {
  //   var url = Uri.parse('https://wash.sortbe.com/API/Wash-Names');

  //   try {
  //     var response = await http.post(
  //       url,
  //       body: {
  //         'enc_key': encKey,
  //         'emp_id': widget.empId,
  //       },
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (responseData['status'] == "Success") {
  //       if (mounted) {
  //         setState(() {
  //           washTypes = (responseData['data'] as List)
  //               .map((item) => WashType.fromJson(item))
  //               .toList();
  //         });
  //       }
  //     } else {
  //       // Handle server error
  //       print('Server error: ${response.statusCode}');
  //     }
  //   } on SocketException catch (e) {
  //     // Handle network error
  //     print('Network error: $e');
  //   } on http.ClientException catch (e) {
  //     // Handle client error
  //     print('Client error: $e');
  //   } catch (e) {
  //     // Handle other errors
  //     print('An error occurred: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      fontSize: 20.0,
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
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AssignedCarList(
                assignedCars: assignedCars,
                start: start.isEmpty ? '0' : start,
                end: end.isEmpty ? '0' : end,
                cleanerKey: widget.empId,
                onAssigned: refreshPage,
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 0),
                  child: Text(
                    'Cars to Wash',
                    style: GoogleFonts.inter(
                      color: AppTemplate.textClr,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredCars.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: 170),
                            Center(
                              child: Text(
                                'No Cars Found...',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          constraints: const BoxConstraints(minHeight: 400),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredCars.length,
                            itemBuilder: (context, index) {
                              return CarsToWashWidget(
                                car: filteredCars[index],
                                cleanerKey: widget.empId,
                                onAssigned: refreshPage,
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
