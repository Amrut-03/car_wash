import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class IndividualSalaryFinal extends StatefulWidget {
  const IndividualSalaryFinal({super.key});

  @override
  State<IndividualSalaryFinal> createState() => _IndividualSalaryFinalState();
}

class _IndividualSalaryFinalState extends State<IndividualSalaryFinal> {
  bool _isChecked = false;
  final TextEditingController additional = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(25.w),
        child: Column(
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
                        color: const Color(0xFFE1E1E1), width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE1E1E1),
                        offset: Offset(0.w, 4.h),
                        blurRadius: 4.r,
                      )
                    ]),
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
                              color: AppTemplate.textClr, width: 1.5.w)),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/p1.png',
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
                        Text(
                          'Suresh',
                          style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: AppTemplate.textClr,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            'No.7 SBI Colony, Trichy - 620 001',
                            style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: const Color(0xFF001C63),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          '+91 98765 41230',
                          style: GoogleFonts.inter(
                              decorationThickness: 1.5.w,
                              fontSize: 11.sp,
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
            Padding(
              padding: EdgeInsets.only(left: 25.w),
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
                  const Text(
                    '2180',
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
                  const Text(
                    '120',
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
                  const Text(
                    '2300',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(120.0),
        border: TableBorder.all(color: Colors.black, width: 2),
        children: [
          _buildTableHeader(),
          _buildTableRow('01/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('02/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('03/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('04/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('05/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('06/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTableRow('07/07/2024', '210(5)', '100(50)', '50', '360'),
          _buildTotalRow(),
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

  TableRow _buildTableRow(
      String date, String wash, String travel, String incentive, String total) {
    return TableRow(
      children: [
        Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(date,
                    style: const TextStyle(fontWeight: FontWeight.bold)))),
        Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(wash,
                    style: const TextStyle(fontWeight: FontWeight.bold)))),
        Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(travel,
                    style: const TextStyle(fontWeight: FontWeight.bold)))),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isChecked = newValue ?? false;
                    });
                  },
                ),
                Text(incentive,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(total,
                    style: const TextStyle(fontWeight: FontWeight.bold)))),
      ],
    );
  }

  TableRow _buildTotalRow() {
    return const TableRow(
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
              '1260',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '600',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '300',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '2160',
              style: TextStyle(
                  color: Color(0xFFC80000), fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
