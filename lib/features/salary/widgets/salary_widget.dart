
import 'package:car_wash/features/Salary/pages/individual_salary.dart';
import 'package:car_wash/features/Salary/pages/individual_salary_final.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryWidget extends StatelessWidget {
  const SalaryWidget({
    super.key,
    required this.text,
    this.show = true,
  });
  final String text;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!show) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IndividualSalary(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IndividualSalaryFinal(),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Container(
          height: 80,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              const Spacer(),
              show
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF447B00),
                      ),
                      child: const Icon(
                        Icons.done,
                        color: AppTemplate.primaryClr,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 15.w),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}


