import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/pages/carWashedDetails.dart';
import 'package:car_wash/features/employee/model/employee_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentWashesList extends StatelessWidget {
  const RecentWashesList({super.key, required this.wash});
  final List<Wash> wash;

  @override
  Widget build(BuildContext context) {
    return wash.isEmpty
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'No washes available',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: wash.length,
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
                              washId: wash[index].washId,
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
                                    wash[index].clientName,
                                    style: GoogleFonts.inter(
                                        color: AppTemplate.textClr,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.0),
                                  ),
                                  Text(
                                    wash[index].washStatus,
                                    style: GoogleFonts.inter(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          statusColor[wash[index].washStatus],
                                      fontSize: 13.0,
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
