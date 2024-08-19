import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/customer/pages/customerProfile.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerController = ref.watch(customerProvider);
    return ListView.builder(
      itemCount: customerController.body.length,
      itemBuilder: (context, index) {
        var customer = customerController.body[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (customer['client_name'] != null) {
                    print(customer['client_name']);
                    print(customer['client_id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerProfile(
                          customerName: customer['client_name'],
                          customerId: customer['id'],
                        ),
                      ),
                    );
                  } else {
                    print("Null data is there");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTemplate.primaryClr,
                    boxShadow: [
                      BoxShadow(
                        color: AppTemplate.shadowClr,
                        blurRadius: 4.r,
                        spreadRadius: 0.r,
                        offset: Offset(0.w, 4.h),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppTemplate.shadowClr),
                  ),
                  child: SizedBox(
                    height: 56.h,
                    width: 310.w,
                    child: Padding(
                      padding: EdgeInsets.all(19.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            customer['client_name'] ?? '',
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                          ),
                          SvgPicture.asset('assets/svg/forward.svg'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h)
            ],
          ),
        );
      },
    );
  }
}
