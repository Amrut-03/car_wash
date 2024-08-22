import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/pages/carWashedDetails.dart';
import 'package:car_wash/features/customer/model/customer_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomerRecentWashesList extends StatelessWidget {
  const CustomerRecentWashesList({
    super.key,
    required this.washList,
    required this.customerName,
  });
  final List<WashListItem> washList;
  final String customerName;

  String formatDate(String? date) {
    String formattedDate;
    print('Date - $date');
    try {
      if (date != null) {
        DateTime parsedDate = DateFormat('dd MMM yyyy hh:mm a').parse(date);
        print('Parsed - $parsedDate');
        formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
        print('Formatted - $formattedDate');
      } else {
        formattedDate = 'Date Unavailable';
      }
    } catch (e) {
      print('Error - ${e.toString()}');
      formattedDate = 'Invalid Date';
    }
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return washList.isEmpty
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'No washes available',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: washList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarWashedDetails(
                              washId: washList[index].id,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              boxShadow: [
                                BoxShadow(
                                    color: AppTemplate.shadowClr,
                                    blurRadius: 4.r,
                                    spreadRadius: 0.r,
                                    offset: Offset(0.w, 4.h))
                              ],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: AppTemplate.shadowClr)),
                          child: SizedBox(
                            height: 56.h,
                            width: 310.w,
                            child: Padding(
                              padding: EdgeInsets.all(19.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    washList[index].washStatus == 'Pending'
                                        ? 'Yet to Start'
                                        : '${customerName}',
                                    style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.0),
                                  ),
                                  Text(
                                    washList[index].washStatus,
                                    style: GoogleFonts.inter(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      color: statusColor[
                                          washList[index].washStatus],
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
