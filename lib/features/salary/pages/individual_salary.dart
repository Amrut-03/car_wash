import 'dart:convert';
import 'dart:developer';

import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/salary/model/get_salary_model.dart';
import 'package:car_wash/features/salary/pages/salary_calender.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class IndividualSalary extends ConsumerStatefulWidget {
  const IndividualSalary({
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
  ConsumerState<IndividualSalary> createState() => _IndividualSalaryState();
}

class _IndividualSalaryState extends ConsumerState<IndividualSalary> {
  bool isLoading = false;
  IncentiveResponse? incentiveResponse;
  final TextEditingController additional = TextEditingController();
  late List<bool> checkboxStates;

  // @override
  // void initState() {
  //   super.initState();
  //   additional.text = '-';
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMonthSalary();
  }

  Future<void> getMonthSalary() async {
    setState(() {
      isLoading = true;
    });
    const url = 'https://wash.sortbe.com/API/Admin/Salary/Get-Salary';

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
            checkboxStates =
                List<bool>.filled(incentiveResponse!.data.length, false);
          });
          if (incentiveResponse!.additionalIncentive != null) {
            additional.text = incentiveResponse!.additionalIncentive!;
          }
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error get = $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateSalary() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> incentiveRecordsJson = [];

    const url = 'https://wash.sortbe.com/API/Admin/Salary/Update-Salary';

    final authState = ref.watch(authProvider);
    print('admin = ${authState.admin!.id}');
    print('emp = ${widget.employeeId}');

    for (var i = 0; i < incentiveResponse!.data.length; i++) {
      String date = incentiveResponse!.data[i].assignedDate;
      int incentive = checkboxStates[i] ? 1 : 0;
      incentiveRecordsJson.add(
        IncentiveRecord(washDate: date, incentive: incentive).toJson(),
      );
    }
    print('Record - $incentiveRecordsJson');
    print('enckey - $encKey');
    print('admin id - ${authState.admin!.id}');
    print('emp id - ${widget.employeeId}');
    print('month - ${widget.month}');
    print('yr - ${widget.year}');
    print('field - ${additional.text}');
    String salaryDataJson = jsonEncode(incentiveRecordsJson);
    print('json - ${salaryDataJson}');
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['enc_key'] = encKey
      ..fields['emp_id'] = authState.admin!.id
      ..fields['user_id'] = widget.employeeId
      ..fields['month'] = widget.month
      ..fields['year'] = widget.year
      ..fields['additional_incentive'] = additional.text
      ..fields['salary_data'] = salaryDataJson;

    try {
      print('Before');
      final response = await request.send();
      print('Sent');
      final responseBody = await response.stream.bytesToString();

      var responseData = jsonDecode(responseBody);
      print('Response - $responseData');
      //Todo:Need to change the success logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salary Generated Successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SalaryCalender(empId: widget.employeeId),
        ),
      );

      // if (responseData['status'] == 'Success') {
      //   var data = responseData['data'];
      //   print('data $data');

      //   setState(() {});
      // } else {
      //   throw Exception('Failed to load data');
      // }
    } catch (e) {
      log('Error update = $e');
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
                  const Header(txt: 'Salary Generation'),
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
                                  return Image.asset(
                                    'assets/images/noavatar.png',
                                    fit: BoxFit.cover,
                                    width: 100.r,
                                    height: 100.r,
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
                            SizedBox(height: 40.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: _buildAdditionalIncentiveField(),
                            ),
                            SizedBox(height: 40.h),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 35.w, right: 35.w, bottom: 35.w),
                              child: _buildGenerateSalaryButton(),
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
        final total = (double.parse(incentiveResponse!.defaultDailyIncentive.toString()) +
                double.parse(incentive.washIncentive) +
                double.parse(incentive.kmIncentive))
            .toString();
        return _buildTableRow(
          incentive.assignedDate,
          incentive.washIncentive,
          incentive.kmIncentive,
          incentiveResponse!.defaultDailyIncentive.toString(),
          total,
          index,
        );
      },
    );

    // Calculate totals
    final totalDaily = incentiveResponse!.data.fold(
        0.0, (sum, item) => sum + double.parse(incentiveResponse!.defaultDailyIncentive.toString()));
    final totalWash = incentiveResponse!.data
        .fold(0.0, (sum, item) => sum + double.parse(item.washIncentive));
    final totalKm = incentiveResponse!.data
        .fold(0.0, (sum, item) => sum + double.parse(item.kmIncentive));
    final grandTotal = totalDaily + totalWash + totalKm;

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
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: checkboxStates[index],
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkboxStates[index] = newValue ?? false;
                    });
                  },
                ),
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

  Widget _buildAdditionalIncentiveField() {
    // if (incentiveResponse!.additionalIncentive == null) {
    //   additional.text = '-';
    // } else {
    //   additional.text = incentiveResponse!.additionalIncentive;
    // }
    return Textfieldwidget(
      controller: additional,
      labelTxt: 'Additional Incentive',
      labelTxtClr: const Color(0xFF929292),
      enabledBorderClr: const Color(0xFFD4D4D4),
      focusedBorderClr: const Color(0xFFD4D4D4),
    );
  }

  Widget _buildGenerateSalaryButton() {
    return Buttonwidget(
      width: 290.w,
      height: 50.h,
      buttonClr: const Color(0xFF1E3763),
      txt: 'Generate Salary',
      textClr: AppTemplate.primaryClr,
      textSz: 18.0,
      onClick: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Confirm Salary Generation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Do you want to generate the salary?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 18, color: AppTemplate.bgClr),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await updateSalary();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 18, color: AppTemplate.bgClr),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
