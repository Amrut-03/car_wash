import 'dart:convert';
import 'dart:developer';

import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/salary/model/get_salary_model.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class IndividualSalaryFinal extends ConsumerStatefulWidget {
  const IndividualSalaryFinal({
    super.key,
    required this.employeeName,
    required this.employeePic,
    required this.employeeId,
    required this.address,
    required this.phone1,
    required this.month,
    required this.year,
  });
  final String employeeName;
  final String employeePic;
  final String employeeId;
  final String address;
  final String phone1;
  final String month;
  final String year;

  @override
  ConsumerState<IndividualSalaryFinal> createState() =>
      _IndividualSalaryFinalState();
}

class _IndividualSalaryFinalState extends ConsumerState<IndividualSalaryFinal> {
  bool isLoading = false;
  IncentiveResponse? incentiveResponse;
  final TextEditingController additional = TextEditingController();
  double totalAmount = 0.00;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewGeneratedSalary();
  }

  Future<void> viewGeneratedSalary() async {
    setState(() {
      isLoading = true;
    });
    const url =
        'https://wash.sortbe.com/API/Admin/Salary/View-Generated-Salary';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');
    print('emp = ${widget.employeeId}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': authState.admin!.id,
          'user_id': widget.employeeId,
          'month': widget.month,
          'year': widget.year,
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response - $responseData');

      if (responseData['status'] == 'Success') {
        var data = responseData['data'];
        print('data $data');

        if (data != null) {
          setState(() {
            incentiveResponse = IncentiveResponse.fromJson(responseData);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error view = $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(25.w),
        child: incentiveResponse == null
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 2),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(txt: 'Salary History'),
                  Padding(
                    padding: EdgeInsets.all(25.w),
                    child: Container(
                      height: 130.h,
                      width: 310.w,
                      decoration: BoxDecoration(
                        color: AppTemplate.primaryClr,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE1E1E1),
                          width: 1.5.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE1E1E1),
                            offset: Offset(0.w, 4.h),
                            blurRadius: 4.r,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25.w,
                          ),
                          Container(
                            height: 92.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE1E1E1),
                                  offset: Offset(0.w, 4.h),
                                  blurRadius: 4.r,
                                )
                              ],
                              borderRadius: BorderRadius.circular(50.r),
                              border: Border.all(
                                  color: AppTemplate.textClr, width: 1.5.w),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.employeePic,
                                fit: BoxFit.cover,
                                width: 100.r,
                                height: 100.r,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100.r,
                                    width: 100.r,
                                    child: Center(
                                      child: Text(
                                        'Failed to load',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120.w,
                                child: Text(
                                  widget.employeeName,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppTemplate.textClr,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 120.w,
                                child: Text(
                                  widget.address,
                                  style: GoogleFonts.inter(
                                      fontSize: 11.0,
                                      color: const Color(0xFF001C63),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Text(
                                widget.phone1,
                                style: GoogleFonts.inter(
                                    decorationThickness: 1.5.w,
                                    fontSize: 11.0,
                                    color: AppTemplate.textClr,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  incentiveResponse!.data.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 6,
                          ),
                          child: Center(
                            child: Text(
                              'No data found...',
                              style: TextStyle(fontSize: 23),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25.w, right: 10.w),
                              child: _buildSalaryTable(),
                            ),
                            SizedBox(height: 30.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text('Total Amount:'),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    '$totalAmount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text('Additional Incentive:'),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    incentiveResponse!.additionalIncentive,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text('Final Salary:'),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    '${double.tryParse(incentiveResponse!.additionalIncentive)! + totalAmount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                ],
              ),
      ),
    );
  }

  Widget _buildSalaryTable() {
    if (incentiveResponse == null || incentiveResponse!.data.isEmpty) {
      return Center(child: Text('No data available'));
    }

    // Extract data from the response
    final rows = List<TableRow>.generate(
      incentiveResponse!.data.length,
      (index) {
        final incentive = incentiveResponse!.data[index];
        final total = (double.parse(incentive.dailyIncentive.toString()) +
                double.parse(incentive.washIncentive) +
                double.parse(incentive.kmIncentive))
            .toString();

        return _buildTableRow(
          incentive.assignedDate,
          incentive.washIncentive,
          incentive.kmIncentive,
          incentive.dailyIncentive.toString(),
          total,
          index,
        );
      },
    );

    // Calculate totals
    final totalDaily = incentiveResponse!.data.fold(
        0.0, (sum, item) => sum + double.parse(item.dailyIncentive.toString()));
    final totalWash = incentiveResponse!.data
        .fold(0.0, (sum, item) => sum + double.parse(item.washIncentive));
    final totalKm = incentiveResponse!.data
        .fold(0.0, (sum, item) => sum + double.parse(item.kmIncentive));
    final grandTotal = totalDaily + totalWash + totalKm;
    totalAmount = grandTotal;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(120.0),
        border: TableBorder.all(color: Colors.black, width: 2),
        children: [
          _buildTableHeader(),
          ...rows,
          _buildTotalRow(totalWash, totalKm, totalDaily, grandTotal),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: ['Date', 'Wash', 'Travel', 'Incentive', 'Total'].map((title) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF001C63),
                    fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(String date, String wash, String travel,
      String incentive, String total, int index) {
    return TableRow(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              wash,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              travel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  incentive,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              total,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTotalRow(
      double washTotal, double kmTotal, double dailyTotal, double total) {
    return TableRow(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Total',
              style: TextStyle(
                  color: Color(0xFFC80000),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '$washTotal',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '$kmTotal',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '$dailyTotal',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '$total',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
